#! /bin/sh

END_POINT="http://avenirs-apache/apisix-api/apisix/admin/routes"

curl -H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1" -i "$END_POINT" -X PUT -d '
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
