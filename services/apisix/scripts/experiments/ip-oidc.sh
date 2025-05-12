#! /bin/bash


curl -H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1" -i "http://localhost/apisix-api/apisix/admin/routes" -X PUT -d '
{
  "name": "IP OIDC",
  "id": "ip-oidc",
  "uri": "/ipoidc",
  "plugins": {
    "proxy-rewrite": {
      "uri": "/ip"
    },
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
  },
  "upstream": {
    "type": "roundrobin",
    "nodes": {
      "httpbin.org:80": 1
    }
  }
}'
