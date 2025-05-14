#! /bin/bash

curl --location --request PUT 'http://127.0.0.1:9180/apisix/admin/routes/oidc-ws' \
--header 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1' \
--header 'Content-Type: application/json' \
--data-raw '{
   "name": "oidc-ws",
    "uri": "/oidc-ws",
    "desc": "Route to test websocket OIDC authentication capabilities of APISIX",
    "methods": ["GET"],
    "enable_websocket": true,
    "upstream": {
    "nodes": [
        {
            "host": "avenirs-node",
            "port": 3003,
            "weight": 1
        }
        ],
        "type": "roundrobin",
        "hash_on": "vars",
        "scheme": "http",
        "pass_host": "pass"
    },
    "labels": {
       "API_VERSION": "0.0.1",
       "AVENIRS_TAG": "experiment"
  },
    "plugins": {
       "openid-connect": {
      "_meta": {
          "disable": false
      },
      "bearer_only": true,
      "client_id": "APIMClientId",
      "client_secret": "ErT322hVLHzIi9Z5tbu58yzUvzVqlsh3T0tmKRV41bu004wqY664TM=",
      "discovery": "https://avenirs-apache/cas/oidc/.well-known",
      "introspection_endpoint": "https://avenirs-apache/cas/oidc/introspect",
      "redirect_uri": "https://httpbin.org",
      "scope": "openid profile email",
      "set_access_token_header": true,
      "token_endpoint_auth_method": "GET"
    }
    }
}'
