#! /bin/sh

END_POINT="http://avenirs-apache/apisix-api/apisix/admin/routes"

curl -H "X-API-KEY: $APISIX_ADMIN_KEY" -i "$END_POINT" -X PUT -d '
{
  "name": "program-progress-skills-overview-route",
  "id": "program-progress-skills-overview-route",
  "uri": "/program-progress/skills/overview",
  "methods": ["GET"],
  "plugin_config_id": "avenirs-access-control-mock",
  
  "upstream": {
    "type": "roundrobin",
    "nodes": {
      "avenirs-portfolio-api:10000": 1
    }
  }
}'
