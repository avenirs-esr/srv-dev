package fr.avenirsesr.cas.saml.fer;

import lombok.val;
import org.apereo.cas.configuration.CasConfigurationProperties;
import org.apereo.cas.web.flow.CasWebflowConstants;
import org.apereo.cas.web.flow.configurer.AbstractCasWebflowConfigurer;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.core.Ordered;
import org.springframework.webflow.definition.registry.FlowDefinitionRegistry;
import org.springframework.webflow.engine.builder.support.FlowBuilderServices;
import org.springframework.webflow.execution.Action;

/**
 * Requires cas.authn.pac4j.core.discovery-selection.selection-type=DYNAMIC - that's what makes CAS build the
 * "discovery" transition and state this configurer reroutes/reuses.
 */
public class FerWayfWebflowConfigurer extends AbstractCasWebflowConfigurer {

    private static final String STATE_ID_FER_WAYF_REDIRECT = "ferWayfRedirect";

    private final Action ferWayfRedirectUrlAction;

    public FerWayfWebflowConfigurer(final FlowBuilderServices flowBuilderServices,
                                     final FlowDefinitionRegistry flowDefinitionRegistry,
                                     final ConfigurableApplicationContext applicationContext,
                                     final CasConfigurationProperties casProperties,
                                     final Action ferWayfRedirectUrlAction) {
        super(flowBuilderServices, flowDefinitionRegistry, applicationContext, casProperties);
        this.ferWayfRedirectUrlAction = ferWayfRedirectUrlAction;
    }

    @Override
    public int getOrder() {
        // Must run after DelegatedAuthenticationWebflowConfigurer, which creates the states this depends on.
        return Ordered.LOWEST_PRECEDENCE;
    }

    @Override
    protected void doInitialize() {
        val flow = getLoginFlow();
        if (flow == null) {
            return;
        }

        val redirectState = createViewState(flow, STATE_ID_FER_WAYF_REDIRECT,
            createExternalRedirectViewFactory("requestScope." + FerWayfRedirectUrlAction.REQUEST_SCOPE_ATTR_REDIRECT_URL));
        // Render action, not entry action: Spring Webflow (re)assigns the flow execution key for this pause
        // right after entry actions run but before rendering - an entry action here would embed the *old*,
        // about-to-be-superseded key in the return URL. Render actions run after key (re)assignment.
        redirectState.getRenderActionList().add(ferWayfRedirectUrlAction);
        createTransitionForState(redirectState, CasWebflowConstants.TRANSITION_ID_EXECUTE,
            CasWebflowConstants.STATE_ID_DELEGATED_AUTHN_DYNAMIC_DISCOVERY_EXECUTION);

        val loginForm = getState(flow, CasWebflowConstants.STATE_ID_VIEW_LOGIN_FORM);
        createTransitionForState(loginForm, CasWebflowConstants.TRANSITION_ID_DISCOVERY,
            STATE_ID_FER_WAYF_REDIRECT, true);
    }
}
