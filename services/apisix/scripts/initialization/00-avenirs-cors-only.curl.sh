#! /bin/sh

END_POINT="http://avenirs-apisix-api:9180/apisix/admin/plugin_configs"

JSON_CONTENT=$(cat <<EOF
{
  "id": "avenirs-cors-only",
  "desc": "Avenirs CORS only for preflight requests",
  "plugins": {
    "cors": {
      "_meta": {
        "disable": false
      },
      "allow_credential": true,
      "allow_headers": "Authorization,Content-Type,Accept,Origin,X-Requested-With,x-authorization,x-signed-context,x-context-signature,x-context-kid,X-Avenirs-Apim-Version",
      "allow_methods": "GET,POST,PUT,PATCH,DELETE,OPTIONS",
      "allow_origins": "http://localhost:5173,https://dev.avenirs-esr.fr,https://qualif.avenirs-esr.fr,https://recette.avenirs-esr.fr",
      "expose_headers": "Content-Disposition",
      "max_age": 3600
    }
  }
}
EOF
)

curl -H "X-API-KEY: $SEC_APISIX_ADMIN_KEY" -i "$END_POINT" -X PUT -d "$JSON_CONTENT"

echo -ne "\n\n"