#! /bin/sh

END_POINT="http://avenirs-apache/apisix-api/apisix/admin/plugin_configs"


JSON_CONTENT=$(cat <<EOF
{
  "id": "avenirs-access-control-mock",
  "desc": "Avenirs access control mock based on serveless-pre-function",
  "plugins": {
    "serverless-pre-function": {
      "phase": "rewrite",
      "functions": [
        "return function(conf, ctx) 

                local core = require(\"apisix.core\");
                local http = require(\"resty.http\");
                local hmac = require(\"resty.hmac\");
                local str = require(\"resty.string\");
                local jwt = require(\"resty.jwt\");
                local inspect = require(\"inspect\");
                local cjson = require(\"cjson\");

                local token_to_uuid = {
                  [\"AT-1-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"49a6840d-d62e-401f-9fd0-8668696c1749\",
                  [\"AT-2-b38sDr3jDnMjph-SSEWqvCJJ6de5XE9s\"] = \"ce86b264-b390-49a1-9365-7d531ecc2c73\",
                  [\"AT-3-z43sDr3jDnMjph-SSEWqvCJJ6de5XE9s\"] = \"8946b501-99ef-4163-b428-52e20f56ebc7\",
                  [\"AT-4-foo34ZEjDnMjph-SSEWqvCJJ6de5XE9s\"] = \"306344d2-27d3-411d-b14a-d522d329abf2\"
                }

                ngx.log(ngx.ERR, \"serverless pre function\");

                local bearer = core.request.header(ctx, \"Authorization\");
                local token = \"\";
                if bearer ~= nil then
                 local _, _, payload = string.find(bearer, \"Bearer%s+(.+)\");
                 token=payload
                end
                ngx.log(ngx.ERR, \"serverless pre function token \",token)
                
                local user_id = token_to_uuid[token]
               if user_id == nil then
                 return 403, {
                  message = \"Forbidden: invalid token\",
                  status = 403,
                  code = \"FORBIDDEN\",  
                  details = {
                      reason = \"Token authentication failed, invalid access token\"
                  }
                }
               end  
           
            local now = ngx.time()
            local user_context = {
                uid = user_id,
                iat = now,
                exp = now + 300
            }
            local payload = cjson.encode(user_context)
            local current_kid = \"v2\"
            local hmac_keys = {
                v1 = \"super-secret-v1\",
                v2 = \"super-secret-v2\"
            }    
            local hmac_key = hmac_keys[current_kid]
            local h = hmac:new(hmac_key, hmac.ALGOS.SHA256)
            h:update(payload)
            local signature = h:final(nil, true)
ngx.log(ngx.ERR, \"serverless pre function signature_bin \",signature_bin)

            --local signature_hex = str.to_hex(signature_bin)
--ngx.log(ngx.ERR, \"serverless pre function signature_hex \",signature_hex)
            core.request.set_header(ctx, \"X-Signed-Context\", user_id)
            core.request.set_header(ctx, \"X-Context-Signature\", signature)
            core.request.set_header(ctx, \"X-Context-Kid\", current_kid)
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