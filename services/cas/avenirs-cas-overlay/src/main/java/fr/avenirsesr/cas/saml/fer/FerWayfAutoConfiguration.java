package fr.avenirsesr.cas.saml.fer;

import com.google.common.cache.Cache;
import com.google.common.cache.CacheBuilder;
import lombok.val;
import org.apache.hc.client5.http.impl.classic.HttpClients;
import org.apereo.cas.configuration.CasConfigurationProperties;
import org.apereo.cas.multitenancy.TenantExtractor;
import org.apereo.cas.pac4j.client.DelegatedClientNameExtractor;
import org.apereo.cas.pac4j.client.DelegatedIdentityProviderFactory;
import org.apereo.cas.pac4j.client.DelegatedIdentityProviders;
import org.apereo.cas.pac4j.discovery.DelegatedAuthenticationDynamicDiscoveryProviderLocator;
import org.apereo.cas.support.pac4j.authentication.clients.DefaultDelegatedIdentityProviders;
import org.apereo.cas.support.saml.OpenSamlConfigBean;
import org.apereo.cas.util.crypto.CertUtils;
import org.apereo.cas.web.CasWebSecurityConfigurer;
import org.apereo.cas.web.flow.CasWebflowConfigurer;
import org.apereo.cas.web.flow.CasWebflowConstants;
import org.apereo.cas.web.flow.CasWebflowExecutionPlanConfigurer;
import org.apereo.cas.web.flow.DelegatedClientAuthenticationConfigurationContext;
import org.opensaml.saml.metadata.resolver.MetadataResolver;
import org.opensaml.saml.metadata.resolver.filter.MetadataFilter;
import org.opensaml.saml.metadata.resolver.filter.impl.SignatureValidationFilter;
import org.opensaml.saml.metadata.resolver.impl.FunctionDrivenDynamicHTTPMetadataResolver;
import org.opensaml.saml.metadata.resolver.impl.MetadataQueryProtocolRequestURLBuilder;
import org.opensaml.security.x509.BasicX509Credential;
import org.opensaml.xmlsec.keyinfo.impl.StaticKeyInfoCredentialResolver;
import org.opensaml.xmlsec.signature.support.impl.ExplicitKeySignatureTrustEngine;
import org.pac4j.core.client.IndirectClient;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.AutoConfiguration;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.core.io.Resource;
import org.springframework.webflow.definition.registry.FlowDefinitionRegistry;
import org.springframework.webflow.engine.builder.support.FlowBuilderServices;
import org.springframework.webflow.execution.Action;

import java.time.Duration;
import java.util.List;

/**
 * See services/cas/README-SAML.md.
 */
@AutoConfiguration
@EnableConfigurationProperties(CasConfigurationProperties.class)
public class FerWayfAutoConfiguration {

    @Bean
    @ConditionalOnMissingBean(name = "delegatedAuthenticationDynamicDiscoveryProviderLocator")
    public DelegatedAuthenticationDynamicDiscoveryProviderLocator delegatedAuthenticationDynamicDiscoveryProviderLocator(
        @Qualifier(DelegatedClientAuthenticationConfigurationContext.BEAN_NAME)
        final DelegatedClientAuthenticationConfigurationContext configContext,
        @Qualifier("ferMdqMetadataResolver") final MetadataResolver ferMdqMetadataResolver,
        @Value("${cas.authn.pac4j.saml[0].client-name}") final String bootstrapClientName,
        final CasConfigurationProperties casProperties,
        @Qualifier("ferMdqResolvedClients") final Cache<String, IndirectClient> ferMdqResolvedClients,
        @Qualifier("ferMdqRelayStateTokens") final Cache<String, String> ferMdqRelayStateTokens) {
        return new FerMdqDynamicDiscoveryProviderLocator(configContext.getIdentityProviders(),
            ferMdqMetadataResolver, bootstrapClientName, casProperties, ferMdqResolvedClients,
            configContext.getSessionStore(), ferMdqRelayStateTokens);
    }

    @Bean
    public Cache<String, IndirectClient> ferMdqResolvedClients() {
        // Read by FerDynamicClientAwareDelegatedIdentityProviders - see that class for why this exists.
        return CacheBuilder.newBuilder()
            .expireAfterWrite(Duration.ofMinutes(10))
            .maximumSize(10_000)
            .build();
    }

    @Bean
    public Cache<String, String> ferMdqRelayStateTokens() {
        // Read by FerRelayStateClientNameExtractor - see FerMdqDynamicDiscoveryProviderLocator for why this exists.
        return CacheBuilder.newBuilder()
            .expireAfterWrite(Duration.ofMinutes(10))
            .maximumSize(10_000)
            .build();
    }

    @Bean
    @ConditionalOnMissingBean(name = "pac4jDelegatedClientNameExtractor")
    public DelegatedClientNameExtractor pac4jDelegatedClientNameExtractor(
        @Qualifier("ferMdqRelayStateTokens") final Cache<String, String> ferMdqRelayStateTokens) {
        return new FerRelayStateClientNameExtractor(ferMdqRelayStateTokens);
    }

    @Bean
    @ConditionalOnMissingBean(name = DelegatedIdentityProviders.BEAN_NAME)
    public DelegatedIdentityProviders delegatedIdentityProviders(
        @Qualifier(TenantExtractor.BEAN_NAME) final TenantExtractor tenantExtractor,
        @Qualifier("pac4jDelegatedClientFactory") final DelegatedIdentityProviderFactory pac4jDelegatedIdentityProviderFactory,
        @Qualifier("ferMdqResolvedClients") final Cache<String, IndirectClient> ferMdqResolvedClients) {
        val defaultProviders = new DefaultDelegatedIdentityProviders(pac4jDelegatedIdentityProviderFactory, tenantExtractor);
        return new FerDynamicClientAwareDelegatedIdentityProviders(defaultProviders, ferMdqResolvedClients);
    }

    @Bean(destroyMethod = "destroy")
    public MetadataResolver ferMdqMetadataResolver(
        @Value("${avenirs.cas.saml-fer-mdq.url}") final String mdqBaseUrl,
        @Value("${avenirs.cas.saml-fer-mdq.signing-certificate}") final Resource signingCertificate,
        @Qualifier(OpenSamlConfigBean.DEFAULT_BEAN_NAME) final OpenSamlConfigBean openSamlConfigBean) throws Exception {
        val httpClient = HttpClients.custom().build();
        val resolver = new FunctionDrivenDynamicHTTPMetadataResolver(httpClient);
        resolver.setId("ferMdqMetadataResolver");
        resolver.setParserPool(openSamlConfigBean.getParserPool());
        resolver.setRequestURLBuilder(new MetadataQueryProtocolRequestURLBuilder(mdqBaseUrl));
        resolver.setMetadataFilter(ferMdqSignatureValidationFilter(signingCertificate));
        resolver.initialize();
        return resolver;
    }

    private MetadataFilter ferMdqSignatureValidationFilter(final Resource signingCertificate) throws Exception {
        val certificate = CertUtils.readCertificate(signingCertificate);
        val credential = new BasicX509Credential(certificate);
        val keyInfoResolver = new StaticKeyInfoCredentialResolver(credential);
        val trustEngine = new ExplicitKeySignatureTrustEngine(keyInfoResolver, keyInfoResolver);
        val filter = new SignatureValidationFilter(trustEngine);
        filter.initialize();
        return filter;
    }

    @Bean
    public Cache<String, String> ferWayfPendingExecutions() {
        // Read by FerWayfRedirectUrlAction / FerWayfReturnController - see FerWayfRedirectUrlAction for why.
        return CacheBuilder.newBuilder()
            .expireAfterWrite(Duration.ofMinutes(10))
            .maximumSize(10_000)
            .build();
    }

    @Bean
    public Action ferWayfRedirectUrlAction(
        @Value("${avenirs.cas.saml-fer-wayf.url}") final String discoveryServiceUrl,
        @Value("${avenirs.cas.saml-fer-wayf.return-id-param:username}") final String returnIdParam,
        @Value("${cas.authn.pac4j.saml[0].service-provider-entity-id}") final String serviceProviderEntityId,
        @Value("${cas.server.prefix}") final String casServerPrefix,
        @Qualifier("ferWayfPendingExecutions") final Cache<String, String> ferWayfPendingExecutions) {
        return new FerWayfRedirectUrlAction(discoveryServiceUrl, returnIdParam, serviceProviderEntityId,
            casServerPrefix, ferWayfPendingExecutions);
    }

    @Bean
    public FerWayfReturnController ferWayfReturnController(
        @Qualifier("ferWayfPendingExecutions") final Cache<String, String> ferWayfPendingExecutions) {
        return new FerWayfReturnController(ferWayfPendingExecutions);
    }

    @Bean
    public CasWebSecurityConfigurer<Void> ferWayfReturnEndpointConfigurer() {
        return new CasWebSecurityConfigurer<>() {
            @Override
            public List<String> getIgnoredEndpoints() {
                return List.of(FerWayfReturnController.ENDPOINT);
            }
        };
    }

    @Bean
    public CasWebflowConfigurer ferWayfWebflowConfigurer(
        @Qualifier(CasWebflowConstants.BEAN_NAME_FLOW_BUILDER_SERVICES) final FlowBuilderServices flowBuilderServices,
        @Qualifier(CasWebflowConstants.BEAN_NAME_FLOW_DEFINITION_REGISTRY) final FlowDefinitionRegistry flowDefinitionRegistry,
        final ConfigurableApplicationContext applicationContext,
        final CasConfigurationProperties casProperties,
        @Qualifier("ferWayfRedirectUrlAction") final Action ferWayfRedirectUrlAction) {
        return new FerWayfWebflowConfigurer(flowBuilderServices, flowDefinitionRegistry,
            applicationContext, casProperties, ferWayfRedirectUrlAction);
    }

    @Bean
    public CasWebflowExecutionPlanConfigurer ferWayfWebflowExecutionPlanConfigurer(
        @Qualifier("ferWayfWebflowConfigurer") final CasWebflowConfigurer ferWayfWebflowConfigurer) {
        return plan -> plan.registerWebflowConfigurer(ferWayfWebflowConfigurer);
    }
}
