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
                  [\"AT-1-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"9fe9516a-a528-4870-8f15-89187e368610\",
                  [\"AT-2-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"ddb5120e-c69e-4c7a-8a77-b7aa5017ca2a\",
                  [\"AT-3-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"ae7740ef-2847-4973-890e-5151707609cd\",
                  [\"AT-4-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"79fd2bea-4b64-42c7-9c22-06b139be2a51\",
                  [\"AT-5-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"cbf64061-a1c3-4876-9877-df2fdbb5d938\",
                  [\"AT-6-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"93281b1f-b752-409e-8fd6-50ac2389763a\",
                  [\"AT-7-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"806ed466-2adc-45fd-9f68-703965b3779c\",
                  [\"AT-8-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"59323334-5b1d-49c2-90d5-1fd2de97efe6\",
                  [\"AT-9-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"e484d7c1-bc00-403e-9522-b06ec544ecb4\",
                  [\"AT-10-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"ad979265-7d67-4306-8d1a-55256b44e5ab\",
                  [\"AT-11-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"626849de-5a42-4d14-8073-c0e4aa109150\",
                  [\"AT-12-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"56a75a55-2f69-456d-a92d-323149a5ab7f\",
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

            --local signature_hex = str.to_hex(signature_bin)
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

curl -H "X-API-KEY: $APISIX_ADMIN_KEY" -i "$END_POINT" -X PUT -d "$JSON_CONTENT"


echo -ne "\n\n"