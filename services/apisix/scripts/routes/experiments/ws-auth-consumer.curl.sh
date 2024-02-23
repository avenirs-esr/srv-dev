#! /bin/bash


curl --location --request PUT 'http://127.0.0.1:9180/apisix/admin/consumers/echo-consumer' \
--header 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1' \
--header 'Content-Type: application/json' \
--data-raw '{
    "username": "jack",
    "plugins": {
        "key-auth": {
            "key": "12345"
        }
    }
}'
