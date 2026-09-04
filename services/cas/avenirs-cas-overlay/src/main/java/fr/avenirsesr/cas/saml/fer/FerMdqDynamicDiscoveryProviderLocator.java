package fr.avenirsesr.cas.saml.fer;

import com.google.common.cache.Cache;
import lombok.RequiredArgsConstructor;
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
import org.pac4j.core.context.session.SessionStore;
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
import java.util.UUID;

/**
 * Resolves the SAML2 IdP for the entityID returned by the FER's WAYF by querying the FER's MDQ service on
 * demand. buildClientForEntity mirrors org.apereo.cas.web.saml2.DelegatedClientSaml2Builder#buildSaml2ClientFromAggregate,
 * reusing the bootstrap SAML2Client's SP-side machinery (decrypter, signing, replay cache, validators...).
 */
@RequiredArgsConstructor
public class FerMdqDynamicDiscoveryProviderLocator implements DelegatedAuthenticationDynamicDiscoveryProviderLocator {

    private final DelegatedIdentityProviders identityProviders;

    private final MetadataResolver mdqMetadataResolver;

    private final String bootstrapClientName;

    private final CasConfigurationProperties casProperties;

    private final Cache<String, IndirectClient> resolvedClientsCache;

    private final SessionStore sessionStore;

    private final Cache<String, String> relayStateTokens;

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
        // response. Carry the real dynamic client name through RelayState instead, via a short opaque
        // token (a full client name is too long/unsafe to trust literally in a RelayState round-trip) -
        // see FerRelayStateClientNameExtractor for where this is read back.
        val relayStateToken = UUID.randomUUID().toString();
        relayStateTokens.put(relayStateToken, singleClient.getName());
        sessionStore.set(webContext, SAML2StateGenerator.SAML_RELAY_STATE_ATTRIBUTE, relayStateToken);

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
        singleClient.setAuthnResponseValidator(bootstrapClient.getAuthnResponseValidator());
        singleClient.setSoapPipelineProvider(new DefaultSOAPPipelineProvider(singleClient));
        singleClient.setLogoutValidator(bootstrapClient.getLogoutValidator());
        singleClient.setRedirectionActionBuilder(new SAML2RedirectionActionBuilder(singleClient));
        singleClient.setCredentialsExtractor(bootstrapClient.getCredentialsExtractor());
        singleClient.setAuthenticator(bootstrapClient.getAuthenticator());
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
