#! /bin/bash
curl -H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1" -i "http://localhost/apisix-api/apisix/admin/routes" -X PUT -d '
{
  "name": "Health",
  "id": "health",
  "uri": "/health",
  "plugins": {
    "proxy-rewrite": {
      "uri": "/node-api/health"
    }
  },
  "upstream": {
    "type": "roundrobin",
    "nodes": {
      "avenirs-apache": 1
    }
  }
}'