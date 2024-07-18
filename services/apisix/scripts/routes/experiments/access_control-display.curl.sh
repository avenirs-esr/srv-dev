#! /bin/bash

curl -H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1" -i "http://localhost/apisix-api/apisix/admin/routes" -X PUT -d '
{
  "name": "display",
  "id": "display",
  "uri": "/display",
    "plugin_config_id": "avenirs-access-control",
  
    "upstream": {
    "type": "roundrobin",
    "nodes": {
      "avenirs-apache": 1
    }
  }
}'
