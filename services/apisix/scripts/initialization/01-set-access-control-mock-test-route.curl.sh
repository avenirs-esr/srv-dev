#! /bin/sh

END_POINT="http://avenirs-apisix-api:9180/apisix/admin/routes"

curl -H "X-API-KEY: $APISIX_ADMIN_KEY" -i "$END_POINT" -X PUT -d '
{
  "name": "access-control-mock-test-route",
  "id": "access-control-mock-test-route",
  "uri": "/access-control-mock-test",
  "plugin_config_id": "avenirs-access-control-mock",
  "plugins": {
    "proxy-rewrite": {
      "uri": "/node-api/auth-mock-test"
    }
  },
  "upstream": {
    "type": "roundrobin",
    "nodes": {
      "avenirs-apache": 1
    }
  }
}'
