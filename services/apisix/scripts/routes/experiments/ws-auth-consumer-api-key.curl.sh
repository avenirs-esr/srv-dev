#! /bin/bash


curl --location --request PUT 'http://127.0.0.1:9180/apisix/admin/consumers' \
--header 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1' \
--header 'Content-Type: application/json' \
--data-raw '{
    "username": "ws_api_key_consumer",
    "plugins": {
        "key-auth": {
            "key": "1234"
        }
    }
}'
