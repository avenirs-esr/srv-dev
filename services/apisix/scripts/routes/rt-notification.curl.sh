#! /bin/bash

curl --location --request PUT 'http://127.0.0.1:9180/apisix/admin/routes/rt-notification' \
--header 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1' \
--header 'Content-Type: application/json' \
--data-raw '{
  "uri": "/rt-notification",
  "name": "rt-notification",
  "desc": "Notification test",
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
        "host": "avenirs-api",
        "port": 10000,
        "weight": 1
      }
    ],
    "timeout": {
      "connect": 300,
      "send": 60,
      "read": 60
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
  "enable_websocket": true,
  "status": 1
}'