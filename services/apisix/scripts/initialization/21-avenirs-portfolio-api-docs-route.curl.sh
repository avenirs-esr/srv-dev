#! /bin/sh

END_POINT="http://avenirs-apache/apisix-api/apisix/admin/routes"

curl -H "X-API-KEY: $APISIX_ADMIN_KEY" -i "$END_POINT" -X PUT -d '
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
