#! /bin/sh

END_POINT="http://avenirs-apache/apisix-api/apisix/admin/plugin_configs"

FAKE_ACCESS_TOKEN="AT-1-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r"

JSON_CONTENT=$(cat <<EOF
{
  "id": "avenirs-auth-mock",
  "desc": "Avenirs auth mock based on serveless-pre-function",
  "plugins": {
    "serverless-pre-function": {
      "phase": "rewrite",
      "functions": [
        "return function(conf, ctx) 

                local core = require(\"apisix.core\");
                local http = require(\"resty.http\")
                local jwt = require(\"resty.jwt\");
                local inspect = require(\"inspect\");
                local cjson = require(\"cjson\");

                ngx.log(ngx.ERR, \"serverless pre function\");

                local bearer = core.request.header(ctx, \"Authorization\");
                local token = \"\";
                if bearer ~= nil then
                 local _, _, payload = string.find(bearer, \"Bearer%s+(.+)\");
                 token=payload
                end
                ngx.log(ngx.ERR, \"serverless pre function token \",token)
                
                
               if token ~= \"${FAKE_ACCESS_TOKEN}\" then
                 return 403, {
                  message = \"Forbidden: invalid token\",
                  status = 403,
                  code = \"FORBIDDEN\",  
                  details = {
                      reason = \"Token authentication failed, invalid access token\"
                  }
                }
               end  

              core.request.set_header(ctx, \"avenirsEndPoint\",ctx.var.uri) ;
                
                
            end"
      ]
    }
  }
}
EOF
)

curl -H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1" -i "$END_POINT" -X PUT -d "$JSON_CONTENT"


echo -ne "\n\n"