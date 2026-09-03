package fr.avenirsesr.cas.saml.fer;

import com.google.common.cache.Cache;
import lombok.RequiredArgsConstructor;
import lombok.val;
import org.springframework.webflow.action.EventFactorySupport;
import org.springframework.webflow.execution.Action;
import org.springframework.webflow.execution.Event;
import org.springframework.webflow.execution.RequestContext;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.UUID;

/**
 * Computes the redirect URL to the FER's WAYF and stores it in request scope for the owning view-state.
 *
 * The flow execution key is not embedded directly in the return URL: CAS's webflow execution keys are large
 * (~8-12KB base64) and exceed Tomcat/reverse-proxy header size limits once embedded in a return URL - a short
 * token is used instead, mapped to the real key server-side (see FerWayfReturnController).
 */
@RequiredArgsConstructor
public class FerWayfRedirectUrlAction implements Action {

    static final String REQUEST_SCOPE_ATTR_REDIRECT_URL = "ferWayfRedirectUrl";

    private final String discoveryServiceUrl;

    private final String returnIdParam;

    private final String serviceProviderEntityId;

    private final String casServerPrefix;

    private final Cache<String, String> pendingExecutions;

    @Override
    public Event execute(final RequestContext requestContext) {
        val flowExecutionKey = requestContext.getFlowExecutionContext().getKey().toString();
        val token = UUID.randomUUID().toString();
        pendingExecutions.put(token, flowExecutionKey);

        val returnUrl = casServerPrefix + FerWayfReturnController.ENDPOINT + "?token=" + token;

        val redirectUrl = discoveryServiceUrl
            + "?entityID=" + URLEncoder.encode(serviceProviderEntityId, StandardCharsets.UTF_8)
            + "&return=" + URLEncoder.encode(returnUrl, StandardCharsets.UTF_8)
            + "&returnIDParam=" + URLEncoder.encode(returnIdParam, StandardCharsets.UTF_8);

        requestContext.getRequestScope().put(REQUEST_SCOPE_ATTR_REDIRECT_URL, redirectUrl);
        return new EventFactorySupport().success(this);
    }
}
