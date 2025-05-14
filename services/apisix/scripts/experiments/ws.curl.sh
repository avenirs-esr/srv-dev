#! /bin/bash

curl --location --request PUT 'http://127.0.0.1:9180/apisix/admin/consumers' \
--header 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1' \
--header 'Content-Type: application/json' \
--data-raw '{
  "uri": "/ws",
  "name": "ws",
  "desc": "Test ws integration",
  "methods": [
    "GET",
    "POST",
    "PUT",
    "DELETE",
    "PATCH",
    "HEAD",
    "OPTIONS",
    "CONNECT",
    "TRACE",
    "PURGE"
  ],
  "upstream": {
    "nodes": [
      {
        "host": "avenirs-node",
        "port": 3003,
        "weight": 1
      }
    ],
    "timeout": {
      "connect": 6,
      "send": 6,
      "read": 6
    },
    "type": "roundrobin",
    "scheme": "http",
    "pass_host": "pass",
    "keepalive_pool": {
      "idle_timeout": 60,
      "requests": 1000,
      "size": 320
    }
  },
  "labels": {
    "API_VERSION": "0.0.1",
    "avenirs-tag": "experiment"
  },
  "enable_websocket": true,
  "status": 1
}'