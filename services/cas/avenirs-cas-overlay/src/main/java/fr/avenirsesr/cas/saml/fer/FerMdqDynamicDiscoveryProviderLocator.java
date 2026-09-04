package fr.avenirsesr.cas.saml.fer;

import com.google.common.cache.Cache;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import lombok.val;
import org.apereo.cas.configuration.CasConfigurationProperties;
import org.apereo.cas.pac4j.client.DelegatedIdentityProviderFactory;
import org.apereo.cas.pac4j.client.DelegatedIdentityProviders;
import org.apereo.cas.pac4j.discovery.DelegatedAuthenticationDynamicDiscoveryProviderLocator;
import org.apereo.cas.pac4j.discovery.DelegatedAuthenticationDynamicDiscoveryProviderLocator.DynamicDiscoveryProviderRequest;
import org.apereo.cas.util.DigestUtils;
import net.shibboleth.shared.resolver.CriteriaSet;
import org.opensaml.core.criterion.EntityIdCriterion;
import org.opensaml.saml.metadata.resolver.MetadataResolver;
import org.opensaml.saml.saml2.metadata.EntityDescriptor;
import org.pac4j.core.client.IndirectClient;
import org.pac4j.core.context.WebContext;
import org.pac4j.saml.client.SAML2Client;
import org.pac4j.saml.context.SAML2ContextProvider;
import org.pac4j.saml.logout.SAML2LogoutActionBuilder;
import org.pac4j.saml.logout.processor.SAML2LogoutProcessor;
import org.pac4j.saml.metadata.SAML2DelegatingMetadataResolver;
import org.pac4j.saml.metadata.SAML2InMemoryMetadataGenerator;
import org.pac4j.saml.redirect.SAML2RedirectionActionBuilder;
import org.pac4j.saml.sso.artifact.DefaultSOAPPipelineProvider;
import org.pac4j.saml.state.SAML2StateGenerator;

import java.util.Optional;

/**
 * Resolves the SAML2 IdP for the entityID returned by the FER's WAYF by querying the FER's MDQ service on
 * demand. buildClientForEntity mirrors org.apereo.cas.web.saml2.DelegatedClientSaml2Builder#buildSaml2ClientFromAggregate,
 * reusing the bootstrap SAML2Client's SP-side machinery (decrypter, signing, replay cache...).
 */
@Slf4j
@RequiredArgsConstructor
public class FerMdqDynamicDiscoveryProviderLocator implements DelegatedAuthenticationDynamicDiscoveryProviderLocator {

    private final DelegatedIdentityProviders identityProviders;

    private final MetadataResolver mdqMetadataResolver;

    private final String bootstrapClientName;

    private final CasConfigurationProperties casProperties;

    private final Cache<String, IndirectClient> resolvedClientsCache;

    @Override
    public Optional<IndirectClient> locate(final DynamicDiscoveryProviderRequest request, final WebContext webContext) throws Throwable {
        val entityId = request.getUserId();
        val entityDescriptor = (EntityDescriptor) mdqMetadataResolver.resolveSingle(new CriteriaSet(new EntityIdCriterion(entityId)));
        if (entityDescriptor == null) {
            return Optional.empty();
        }

        val bootstrapClient = identityProviders.findClient(bootstrapClientName, webContext)
            .filter(SAML2Client.class::isInstance)
            .map(SAML2Client.class::cast)
            .orElse(null);
        if (bootstrapClient == null) {
            return Optional.empty();
        }

        val singleClient = buildClientForEntity(bootstrapClient, entityDescriptor);
        singleClient.init();
        // See FerDynamicClientAwareDelegatedIdentityProviders for why this cache exists.
        resolvedClientsCache.put(singleClient.getName(), singleClient);

        // singleClient reuses the bootstrap client's federation-registered SP metadata (see
        // buildClientForEntity), so the AssertionConsumerServiceURL in the AuthnRequest - and thus the
        // "client_name" the IdP echoes back - is forever the bootstrap client's, baked in at its own
        // init() time. CAS would otherwise resolve the wrong (bootstrap) client when validating the IdP's
        // response. The real dynamic client name is instead recovered from RelayState, keyed by the
        // TransientSessionTicket id CAS itself stores there a moment later (see FerRelayStateClientTracker,
        // which records that ticket id -> this client name, and FerRelayStateClientNameExtractor, which
        // reads it back). Nothing needs to be done with RelayState here.
        return Optional.of(singleClient);
    }

    private SAML2Client buildClientForEntity(final SAML2Client bootstrapClient, final EntityDescriptor entityDescriptor) {
        val baseConfiguration = bootstrapClient.getConfiguration();
        val singleConfiguration = baseConfiguration.withMetadataGenerator(new SAML2InMemoryMetadataGenerator());
        singleConfiguration.setIdentityProviderEntityId(entityDescriptor.getEntityID());
        singleConfiguration.setIdentityProviderMetadataResolver(new SAML2DelegatingMetadataResolver(entityDescriptor));
        singleConfiguration.setCredentialProvider(baseConfiguration.getCredentialProvider());

        val singleClient = new SAML2Client(singleConfiguration);
        singleClient.setDecrypter(bootstrapClient.getDecrypter());
        singleClient.setSignatureSigningParametersProvider(bootstrapClient.getSignatureSigningParametersProvider());
        singleClient.setContextProvider(new SAML2ContextProvider(singleConfiguration.getIdentityProviderMetadataResolver(),
            bootstrapClient.getServiceProviderMetadataResolver(), bootstrapClient.getConfiguration().getSamlMessageStoreFactory()));
        singleClient.setReplayCache(bootstrapClient.getReplayCache());
        // authnResponseValidator/logoutValidator/authenticator/credentialsExtractor intentionally left unset
        // (unlike CAS's own createSaml2Client, which this method mirrors): each one captures a reference back
        // to its originating client's contextProvider/configuration/validator AT CONSTRUCTION TIME (see
        // org.pac4j.saml.credentials.authenticator.SAML2Authenticator and
        // org.pac4j.saml.credentials.extractor.SAML2CredentialsExtractor), so reusing the bootstrap's would
        // silently keep building/validating the SAML message context against the bootstrap's fixed,
        // bootstrap-only IdP - even with contextProvider/authnResponseValidator freshly scoped to this
        // entityDescriptor everywhere else. singleClient.init() below builds all of these fresh instead.
        singleClient.setSoapPipelineProvider(new DefaultSOAPPipelineProvider(singleClient));
        singleClient.setRedirectionActionBuilder(new SAML2RedirectionActionBuilder(singleClient));
        singleClient.setLogoutProcessor(new SAML2LogoutProcessor(singleClient));
        singleClient.setLogoutActionBuilder(new SAML2LogoutActionBuilder(singleClient));
        singleClient.setServiceProviderMetadataResolver(bootstrapClient.getServiceProviderMetadataResolver());
        singleClient.setStateGenerator(new SAML2StateGenerator(singleClient));
        singleClient.setWebSsoMessageSender(bootstrapClient.getWebSsoMessageSender());
        singleClient.setLogoutRequestMessageSender(bootstrapClient.getLogoutRequestMessageSender());

        val samlProperties = casProperties.getAuthn().getPac4j().getSaml().getFirst();
        val clientName = bootstrapClient.getName() + '-' + DigestUtils.sha256(entityDescriptor.getEntityID());
        DelegatedIdentityProviderFactory.configureClientName(singleClient, clientName);
        DelegatedIdentityProviderFactory.configureClientCustomProperties(singleClient, samlProperties);
        DelegatedIdentityProviderFactory.configureClientCallbackUrl(singleClient, samlProperties, casProperties.getServer().getLoginUrl());
        DelegatedIdentityProviderFactory.configureLogoutPropagation(singleClient, samlProperties);
        return singleClient;
    }
}
