#! /bin/sh

END_POINT="http://avenirs-apisix-api:9180/apisix/admin/routes"

curl -H "X-API-KEY: $SEC_APISIX_ADMIN_KEY" -i "$END_POINT" -X PUT -d '
{
  "name": "api-docs-route",
  "id": "api-docs-route",
  "uri": "/avenirs-portfolio-api/api-docs",
  "methods": ["GET", "OPTIONS"],
  "labels": {"": "SPECS"},
  
  
  "upstream": {
    "pass_host": "pass",
    "type": "roundrobin",
    "nodes": {
      "avenirs-portfolio-api:10000": 1
    }
  }
}'
