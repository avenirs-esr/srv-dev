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
      "introspection_endpoint": "https://avenirs-apache/cas/oidc/introspect",
      "redirect_uri": "https?://avenirs-apache/node-api/cas-auth-callback(.*)",
      "scope": "openid profile email",
      "bearer_only": true,
      "realm": "avenirs",
      "introspection_endpoint_auth_method": "client_secret_basic",
      "set_access_token_header": true,
      "token_endpoint_auth_method": "GET"
    }
  }
}
EOF
)

curl -H "X-API-KEY: $SEC_APISIX_ADMIN_KEY" -i "$END_POINT" -X PUT -d "$JSON_CONTENT"


echo -ne "\n\n"