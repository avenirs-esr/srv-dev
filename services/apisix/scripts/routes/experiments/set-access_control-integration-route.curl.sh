#! /bin/bash

END_POINT="http://localhost/apisix-api/apisix/admin/routes"

[ "$1" = "-d" -o "$1" = "--srv-dev" ] \
&& { END_POINT="http://srv-dev-avenir.srv-avenir.brgm.recia.net/apisix-api/apisix/admin/routes"; shift; } 


curl -H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1" -i "$END_POINT" -X PUT -d '
{
  "name": "ac-in-apim",
  "id": "ac-in-apim",
  "uri": "/ac-in-apim",
    "plugin_config_id": "avenirs-access-control",
  
    "upstream": {
    "type": "roundrobin",
    "nodes": {
      "avenirs-apache": 1
    }
  }
}'
