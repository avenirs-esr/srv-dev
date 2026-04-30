#! /bin/sh


END_POINT="http://avenirs-apisix-api:9180/apisix/admin/plugin_configs"


JSON_CONTENT=$(cat <<EOF
{
  "id": "avenirs-oidc",
  "desc": "Avenirs OpenID Connect authentication configuration",
  "plugins": {
    "openid-connect": {
      "client_id": "$SEC_APISIX_OIDC_CLIENT_ID",
      "client_secret": "$SEC_APISIX_OIDC_CLIENT_SECRET",
      "discovery": "https://avenirs-apache/cas/oidc/.well-known",
      "redirect_uri": "https?://avenirs-apache/node-api/cas-auth-callback(.*)",
      "scope": "openid profile email offline_access",
      "response_type": "code",
      "bearer_only": false,
      "realm": "avenirs",

      "token_endpoint_auth_method": "client_secret_post",
      "introspection_endpoint": "https://avenirs-apache/cas/oidc/introspect",
      "introspection_endpoint_auth_method": "client_secret_basic",

      "set_access_token_header": true,
      "access_token_in_authorization_header": true,

      "session": {
        "secret": "$SEC_APISIX_SESSION_SECRET",
        "cookie": {
          "samesite": "Lax",
          "secure": true,
          "httponly": true
        }
      }
    }
  }
}
EOF
)

curl -H "X-API-KEY: $SEC_APISIX_ADMIN_KEY" -i "$END_POINT" -X PUT -d "$JSON_CONTENT"


echo -ne "\n\n"