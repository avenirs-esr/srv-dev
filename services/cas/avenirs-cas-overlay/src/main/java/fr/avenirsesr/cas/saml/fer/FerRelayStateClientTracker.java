package fr.avenirsesr.cas.saml.fer;

import com.google.common.cache.Cache;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.apereo.cas.support.pac4j.authentication.clients.DelegatedClientSessionManager;
import org.apereo.cas.ticket.TransientSessionTicket;
import org.pac4j.core.client.Client;
import org.pac4j.core.context.WebContext;
import org.pac4j.saml.client.SAML2Client;

/**
 * CAS's own org.apereo.cas.web.saml2.DelegatedClientSaml2SessionManager already stores its
 * TransientSessionTicket id as the pac4j SAML RelayState (SAML2StateGenerator.SAML_RELAY_STATE_ATTRIBUTE),
 * overwriting - in that same session attribute - whatever RelayState FerMdqDynamicDiscoveryProviderLocator
 * set beforehand for its own purpose (recovering the real per-entity dynamic client name on the way back,
 * since the shared bootstrap ACS URL always carries client_name=<bootstrap>). Since
 * DefaultDelegatedClientAuthenticationWebflowManager#store invokes every registered
 * DelegatedClientSessionManager for a given client, this one piggybacks on the same ticket id CAS is
 * going to send as RelayState anyway, instead of fighting it - see FerRelayStateClientNameExtractor for
 * where this mapping is read back.
 */
@Slf4j
@RequiredArgsConstructor
public class FerRelayStateClientTracker implements DelegatedClientSessionManager {

    private final Cache<String, String> relayStateTokens;

    @Override
    public boolean supports(final Client client) {
        return client instanceof SAML2Client;
    }

    @Override
    public void trackIdentifier(final WebContext webContext, final TransientSessionTicket ticket, final Client client) {
        relayStateTokens.put(ticket.getId(), client.getName());
        LOGGER.warn("FER DEBUG: tracked delegated auth ticket [{}] -> dynamic client [{}]", ticket.getId(), client.getName());
    }

    @Override
    public String retrieveIdentifier(final WebContext webContext, final Client client) {
        return StringUtils.EMPTY;
    }
}
