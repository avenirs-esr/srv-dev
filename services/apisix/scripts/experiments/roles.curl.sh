#! /bin/bash
curl -H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1" -i "http://localhost/apisix-api/apisix/admin/routes" -X PUT -d '
{
  "name": "Roles",
  "id": "roles",
  "uri": "/roles",
  "upstream": {
    "type": "roundrobin",
    "nodes": {
      "pc-arnaud:11000": 1
    }
  }
}'