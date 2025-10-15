#! /bin/sh

END_POINT="http://avenirs-apisix-api:9180/apisix/admin/routes"

curl -H "X-API-KEY: $SEC_APISIX_ADMIN_KEY" -i "$END_POINT" -X PUT -d '
{
  "name": "back-office-docs-route",
  "id": "back-office-docs-route",
  "uri": "/avenirs-portfolio-back-office/api-docs",
  "methods": ["GET", "OPTIONS"],
  "labels": {"": "SPECS"},
  
  "upstream": {
    "pass_host": "pass",
    "type": "roundrobin",
    "nodes": {
      "avenirs-portfolio-back-office:10010": 1
    }
  }
}'
