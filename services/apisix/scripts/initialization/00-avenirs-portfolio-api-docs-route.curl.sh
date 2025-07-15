#! /bin/sh

END_POINT="http://avenirs-apisix-api:9180/apisix/admin/routes"

curl -H "X-API-KEY: $SEC_APISIX_ADMIN_KEY" -i "$END_POINT" -X PUT -d '
{
  "name": "avenirs-portfolio-api-docs-route",
  "id": "avenirs-portfolio-api-docs-route",
  "uri": "/avenirs-portfolio-api/api-docs",
  "methods": ["GET"],
  
  
  "upstream": {
    "type": "roundrobin",
    "nodes": {
      "avenirs-portfolio-api:10000": 1
    }
  }
}'
