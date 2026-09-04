package fr.avenirsesr.cas.saml.fer;

import com.google.common.cache.Cache;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.val;
import org.apereo.cas.pac4j.client.DelegatedClientNameExtractor;
import org.pac4j.core.context.WebContext;

import java.util.Optional;

/**
 * Recovers the real per-entity dynamic SAML2 client name from a RelayState token - see
 * FerMdqDynamicDiscoveryProviderLocator for why CAS's default "client_name" request parameter always
 * resolves to the bootstrap FER client instead. Falls back to CAS's default extraction for anything
 * that isn't part of the FER MDQ dynamic discovery flow (other delegated providers, logout, ...).
 */
@RequiredArgsConstructor
public class FerRelayStateClientNameExtractor implements DelegatedClientNameExtractor {

    private static final String RELAY_STATE_PARAMETER = "RelayState";

    private final Cache<String, String> relayStateTokens;

    @Override
    public Optional<String> extract(final HttpServletRequest request) {
        return DelegatedClientNameExtractor.fromHttpRequest().extract(request);
    }

    @Override
    public Optional<String> extract(final WebContext context) {
        val relayState = context.getRequestParameter(RELAY_STATE_PARAMETER).orElse(null);
        val resolvedClientName = relayState == null ? null : relayStateTokens.getIfPresent(relayState);
        return resolvedClientName != null
            ? Optional.of(resolvedClientName)
            : DelegatedClientNameExtractor.fromHttpRequest().extract(context);
    }
}
