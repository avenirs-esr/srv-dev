#! /bin/bash

curl --location --request PUT 'http://127.0.0.1:9180/apisix/admin/consumers' \
--header 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1' \
--header 'Content-Type: application/json' \
--data-raw '{
  "uri": "/kafka",
  "name": "kafka",
  "upstream": {
    "nodes": [
      {
        "host": "avenirs-kafka",
        "port": 9092,
        "weight": 1
      }
    ],
    "timeout": {
      "connect": 6,
      "send": 6,
      "read": 6
    },
    "type": "none",
    "scheme": "kafka",
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