package fr.avenirsesr.cas.saml.fer;

import com.google.common.cache.Cache;
import lombok.RequiredArgsConstructor;
import lombok.val;
import org.apereo.cas.web.flow.CasWebflowConstants;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.util.HtmlUtils;

/**
 * Resolves the short-lived token minted by FerWayfRedirectUrlAction back to the real (large) flow execution
 * key, and resumes the paused login webflow via an auto-submitted POST - see FerWayfRedirectUrlAction for why
 * this indirection exists (the real key is too large to survive a GET redirect chain through the FER's WAYF).
 */
@RestController
@RequiredArgsConstructor
public class FerWayfReturnController {

    static final String ENDPOINT = "/wayfReturn";

    private final Cache<String, String> pendingExecutions;

    @GetMapping(ENDPOINT)
    public ResponseEntity<String> resume(@RequestParam("token") final String token,
                                          @RequestParam("username") final String username) {
        val executionKey = pendingExecutions.getIfPresent(token);
        if (executionKey == null) {
            return ResponseEntity.status(HttpStatus.GONE).body("Expired or unknown WAYF return token.");
        }
        pendingExecutions.invalidate(token);

        val html = "<!DOCTYPE html><html><head><title>Redirecting...</title></head>"
            + "<body onload=\"document.forms[0].submit()\">"
            + "<form method=\"post\" action=\"login\">"
            + "<input type=\"hidden\" name=\"execution\" value=\"" + HtmlUtils.htmlEscape(executionKey) + "\"/>"
            + "<input type=\"hidden\" name=\"_eventId\" value=\"" + CasWebflowConstants.TRANSITION_ID_EXECUTE + "\"/>"
            + "<input type=\"hidden\" name=\"username\" value=\"" + HtmlUtils.htmlEscape(username) + "\"/>"
            + "</form></body></html>";

        return ResponseEntity.ok().contentType(MediaType.TEXT_HTML).body(html);
    }
}
