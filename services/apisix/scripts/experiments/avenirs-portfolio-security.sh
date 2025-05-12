#! /bin/bash
curl -H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1" -i "http://localhost/apisix-api/apisix/admin/routes" -X PUT -d '
{
  "name": "OIDC Callback",
  "id": "oidc-callback",
  "uri": "/oidc/callback",
  "desc": "OIDC Authentication callback",
  "methods": [
    "GET"
  ],
  "upstream": {
    "type": "roundrobin",
    "nodes": {
      "avenirs-portfolio-security:12000": 1
    }
  }
}'

curl -H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1" -i "http://localhost/apisix-api/apisix/admin/routes" -X PUT -d '
{
  "name": "OIDC Redirect",
  "id": "oidc-redirect",
  "uri": "/oidc/redirect",
  "desc": "OIDC Authentication redirect",
  "methods": [
    "GET"
  ],
  "upstream": {
    "type": "roundrobin",
    "nodes": {
      "avenirs-portfolio-security:12000": 1
    }
  }
}'