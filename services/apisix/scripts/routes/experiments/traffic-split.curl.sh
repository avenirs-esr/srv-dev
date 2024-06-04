#! /bin/bash

curl -H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1" -i "http://localhost/apisix-api/apisix/admin/routes" -X PUT -d '
{
    "name": "dynamic-upstream-tmp",
  "id": "dynupstrtmp",
  "uri": "/ds",
    "plugins": {
        "proxy-rewrite": {
            "uri": "/node-api/ds"
        },
        "traffic-split": {
            "rules": [{
            "match": [{
                "vars": [
                [
                    "http_avenirs-establishment",
                    "==",
                    "univ1"
                ]
                ]
            }],
            "weighted_upstreams": [{
                "upstream": {
                "name": "upstream_A",
                "nodes": {
                     "avenirs-api:80": 10
                },
                "type": "roundrobin"
                }
            }]
            }]
        }
    },
  
    "upstream": {
    "type": "roundrobin",
    "nodes": {
      "avenirs-apache": 1
    }
  }
}'



curl -H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1" -i "http://localhost/apisix-api/apisix/admin/routes/dynupstrtmp" -X GET
