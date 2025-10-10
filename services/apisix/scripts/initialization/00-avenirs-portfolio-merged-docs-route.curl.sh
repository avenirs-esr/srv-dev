#! /bin/sh

END_POINT="http://avenirs-apisix-api:9180/apisix/admin/routes"

curl -H "X-API-KEY: $SEC_APISIX_ADMIN_KEY" -i "$END_POINT" -X PUT -d '
{
  "name": "merged-docs-route",
  "id": "merged-docs-route",
  "uri": "/api-specs/openapi-merged.json",
  "methods": ["GET", "OPTIONS"],
  
  
  "upstream": {
    "pass_host": "pass",
    "type": "roundrobin",
    "nodes": {
      "le-apache:80": 1
    }
  }
}'
