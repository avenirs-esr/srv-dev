package fr.avenirsesr.cas.saml.fer;

import com.google.common.cache.Cache;
import lombok.RequiredArgsConstructor;
import lombok.val;
import org.apereo.cas.authentication.principal.Service;
import org.apereo.cas.pac4j.client.DelegatedIdentityProviders;
import org.pac4j.core.client.Client;
import org.pac4j.core.client.IndirectClient;
import org.pac4j.core.context.WebContext;

import java.util.ArrayList;
import java.util.List;

/**
 * Wraps CAS's default {@link DelegatedIdentityProviders} to also expose the SAML2 clients built dynamically
 * by FerMdqDynamicDiscoveryProviderLocator via MDQ - CAS's own DefaultDelegatedIdentityProviders rebuilds its
 * client list from static configuration (cas.authn.pac4j.*) on every call, so a client we build on the fly
 * would otherwise be findable only during the exact request that created it. The webflow does not actually
 * redirect to the IdP from that request though: it hands off to a separate "/clientredirect" flow that
 * re-looks up the client by name, which is why dynamically-built clients must be cached here to stay
 * findable across that second request.
 */
@RequiredArgsConstructor
public class FerDynamicClientAwareDelegatedIdentityProviders implements DelegatedIdentityProviders {

    private final DelegatedIdentityProviders delegate;

    private final Cache<String, IndirectClient> dynamicallyResolvedClients;

    @Override
    public List<? extends Client> findAllClients(final Service service, final WebContext webContext) {
        val clients = new ArrayList<Client>(delegate.findAllClients(service, webContext));
        clients.addAll(dynamicallyResolvedClients.asMap().values());
        return clients;
    }
}
