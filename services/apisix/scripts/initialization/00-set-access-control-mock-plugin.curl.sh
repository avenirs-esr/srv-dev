#! /bin/sh

END_POINT="http://avenirs-apisix-api:9180/apisix/admin/plugin_configs"


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
                  [\"AT-1-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"44139402-8a4a-4e7b-806e-9d7d5a7252af\",
                  [\"AT-2-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"6b8024ea-062b-41ce-b9e2-49eeaa98c2e7\",
                  [\"AT-3-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"2f6ec552-7a87-4b0c-8019-57000f95282e\",
                  [\"AT-4-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"eec650fd-6b2d-42bb-b9c6-eae6186fd82f\",
                  [\"AT-5-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"a10a6389-135a-40c5-9c5d-0280e6e25440\",
                  [\"AT-6-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"b8b392a0-6d83-4e91-b253-40c85f8f216f\",
                  [\"AT-7-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"476eca82-4c47-42f1-9aa0-d2e8a38d058d\",
                  [\"AT-8-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"a6387d5e-71c9-427e-9d3f-1c1afe0f527a\",
                  [\"AT-9-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"5fd69d5c-2e45-42e8-b997-520bf7801127\",
                  [\"AT-10-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"96edb2ed-0649-4cc4-8fc0-6d6b985a55e1\",
                  [\"AT-11-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"ef8c8bb3-7dc8-4d30-bba2-70bcaa3c2219\",
                  [\"AT-12-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"d8d42432-1918-4605-88a1-7dfc541ba532\",
                  [\"AT-13-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"0fc19869-fb21-4112-abb8-fdf038c7c462\",
                  [\"AT-14-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"d7e82645-da79-47b2-9236-dde53c7abe53\",
                  [\"AT-15-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"765fb4bc-0e8d-494d-8a8d-eddad3f1433e\",
                  [\"AT-16-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"d35a440d-edc2-4607-b0e6-6b1dacda48ab\",
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
                sub = user_id,
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
            local signature_bin = h:final(nil, false)
            local signature_base64 = ngx.encode_base64(signature_bin)
            core.request.set_header(ctx, \"X-Signed-Context\", payload)
            core.request.set_header(ctx, \"X-Context-Signature\", signature_base64)
            core.request.set_header(ctx, \"X-Context-Kid\", current_kid)
            ngx.req.clear_header(\"Authorization\")
            core.request.set_header(ctx, \"avenirsEndPoint\",ctx.var.uri)
                
                
            end"
      ]
    }
  }
}
EOF
)

curl -H "X-API-KEY: $APISIX_ADMIN_KEY" -i "$END_POINT" -X PUT -d "$JSON_CONTENT"


echo -ne "\n\n"