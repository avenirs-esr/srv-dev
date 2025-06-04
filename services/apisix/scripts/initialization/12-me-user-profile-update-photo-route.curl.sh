#! /bin/sh

END_POINT="http://avenirs-apache/apisix-api/apisix/admin/routes"

curl -H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1" -i "$END_POINT" -X PUT -d '
{
  "name": "me-user-profile-update-photo-route",
  "id": "me-user-profile-update-photo-route",
  "uri": "/me/user/*/update/photo",
  "methods": ["PUT"],
  "plugin_config_id": "avenirs-access-control-mock",
  
  "upstream": {
    "type": "roundrobin",
    "nodes": {
      "avenirs-portfolio-api:10000": 1
    }
  }
}'
