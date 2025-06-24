#! /bin/sh

END_POINT="http://avenirs-apisix-api:9180/apisix/admin/routes"

curl -H "X-API-KEY: $APISIX_ADMIN_KEY" -i "$END_POINT" -X PUT -d '
{
  "name": "getamsview-route",
  "id": "getamsview-route",
  "uri": "/me/ams/view",
  "methods": ["GET"],
  "plugin_config_id": "avenirs-access-control-mock",
  "upstream": {
    "type": "roundrobin",
    "nodes": {
      "avenirs-portfolio-api:10000": 1
    }
  }
}'
