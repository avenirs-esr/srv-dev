#! /bin/sh

END_POINT="http://avenirs-apache/apisix-api/apisix/admin/routes"

curl -H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1" -i "$END_POINT" -X PUT -d '
{
  "name": "auth-mock-test-route",
  "id": "auth-mock-test-route",
  "uri": "/auth-mock-test",
  "plugin_config_id": "avenirs-auth-mock",
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
