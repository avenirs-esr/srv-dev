#! /bin/bash

curl --location --request PUT 'http://127.0.0.1:9180/apisix/admin/routes/api-key-ws' \
--header 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1' \
--header 'Content-Type: application/json' \
--data-raw '{
  "uri": "/api-key-ws",
  "name": "api-key-ws",
  "desc": "Route to test API Key websocket authentication capabilities of APISIX",
  "methods": [
    "GET"
  ],
  "plugins": {
    "key-auth": {
      "header": "apikey",
      "hide_credentials": false,
      "query": "apikey"
    }   
  },
  "upstream": {
    "nodes": [
      {
        "host": "avenirs-node",
        "port": 3003,
        "weight": 1
      }
    ],
    "type": "roundrobin",
    "hash_on": "vars",
    "scheme": "http",
    "pass_host": "pass"
  },
  "labels": {
    "API_VERSION": "0.0.1",
    "AVENIRS_TAG": "experiment"
  },
  "enable_websocket": true,
  "status": 1
}'
