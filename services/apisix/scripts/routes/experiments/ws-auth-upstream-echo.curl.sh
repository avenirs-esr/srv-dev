#! /bin/bash

curl --location --request PUT 'http://127.0.0.1:9180/apisix/admin/routes/echo' \
--header 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1' \
--header 'Content-Type: application/json' \
--data-raw '{
   "name": "echo",
    "uri": "/echo",
    "desc": "Route to test websocket authentication capabilities of APISIX",
    "methods": ["GET"],
    "enable_websocket": true,
    "upstream": {
        "type": "roundrobin",
        "nodes": {
            "ws.postman-echo.com:443": 1
        },
        "scheme": "https"
    },
    "labels": {
       "API_VERSION": "0.0.1",
       "AVENIRS_TAG": "experiment"
  },
    "plugins": {
        "proxy-rewrite": {
            "uri": "/raw"
        },
        "key-auth": {}
    }
}'
