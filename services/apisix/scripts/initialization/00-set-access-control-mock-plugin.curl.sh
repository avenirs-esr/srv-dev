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

                if ctx.var.request_method == \"OPTIONS\" then
                  return
                end

                local core = require(\"apisix.core\");
                local http = require(\"resty.http\");
                local hmac = require(\"resty.hmac\");
                local str = require(\"resty.string\");
                local jwt = require(\"resty.jwt\");
                local inspect = require(\"inspect\");
                local cjson = require(\"cjson\");

                local token_to_uuid = {
                  [\"AT-1-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"0a8700ab-90b6-4a38-8338-acbdd4fbcd3d\",
                  [\"AT-2-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"7c508ac3-d7a8-4f00-9989-0f677f4f9dea\",
                  [\"AT-3-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"0bdebb55-0c48-45d4-9490-a6f85423e87b\",
                  [\"AT-4-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"c25498db-525f-4322-90ec-517582295718\",
                  [\"AT-5-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"57ff122f-ff76-4d95-b6c1-61a4efeabd80\",
                  [\"AT-6-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"ddc4a3cf-2843-4497-99d4-daa6fdfab16b\",
                  [\"AT-7-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"12947983-0266-47b1-a355-d6b1b31051aa\",
                  [\"AT-8-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"cdf03b3f-b76d-40a6-a9e6-069f15fc5af7\",
                  [\"AT-9-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"9b9c49f8-e537-4649-a035-67920cb643fb\",
                  [\"AT-10-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"31820daa-0e02-48e4-9804-a0c79a760e86\",
                  [\"AT-11-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"772645d7-7b84-4b09-8c27-9a2e0e28ada7\",
                  [\"AT-12-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"5fcd76c5-017c-4d61-99d2-62a6f199c94e\",
                  [\"AT-13-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"d6d2040d-2b96-46ea-9d92-2c221e4d60bf\",
                  [\"AT-14-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"e7fb5f27-3d58-4321-af3d-02792030f39d\",
                  [\"AT-15-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"72aba383-5fb0-4268-8821-a241f3dbe8ee\",
                  [\"AT-16-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"ba6d41cf-7d2d-408c-b230-aa0f966e7795\",
                  [\"AT-17-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"d999193b-1835-43ee-b739-bd3209e95756\",
                  [\"AT-18-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"77662aa9-3800-430d-bd0d-1f4d0690189c\",
                  [\"AT-19-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"66e64c71-5664-4c75-b69a-2afdabb8e851\",
                  [\"AT-20-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"8b3c06da-3529-4aac-891e-4358c39f0b05\",
                  [\"AT-21-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"ecd18c24-96fc-4abb-949b-f62a254c0096\",
                  [\"AT-22-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"ce2d4be7-1c70-46d2-b55e-ba3692cb171d\",
                  [\"AT-23-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"a630487e-76ef-4afc-92f9-2c8d80d0aae6\",
                  [\"AT-24-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"25be402a-4130-4fc1-8cff-f3f55841ed67\",
                  [\"AT-25-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"c2c20f28-36f2-4584-afa2-33efbf5b134b\",
                  [\"AT-26-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"9cdfa9b4-81ee-4efa-8574-f1725b8d57e3\",
                  [\"AT-27-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"152adf1d-62ae-4925-aea3-fd3c149a18c8\",
                  [\"AT-28-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"284797b5-4b58-458f-b345-9f0a4e844a06\",
                  [\"AT-29-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"2c7c3160-5361-4cda-a8bc-4714d985541e\",
                  [\"AT-30-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"603d7c13-76d3-476a-a3fb-8d474b2bc79d\",
                  [\"AT-31-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"6511e45d-961b-47c4-94e5-b45a3de1a965\",
                  [\"AT-32-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"c1c3f21c-6eb7-44e6-aa19-61b219d5fd28\",
                  [\"AT-33-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"d40670a4-8755-4b5c-9c4e-aed33b64e127\",
                  [\"AT-34-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"573bf121-0071-4490-8bae-d4d8e6dfa233\",
                  [\"AT-35-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"33392218-dc7f-4eb1-a837-d5cde0b691bf\",
                  [\"AT-36-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"5cb65d4f-2e16-41a3-acbf-8f3376c3c7c6\",
                  [\"AT-37-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"8652c8c0-2d62-4d41-819c-b59fb07e6e4e\",
                  [\"AT-38-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"5f2a889c-8370-4381-99ea-d2467cddbe0b\",
                  [\"AT-39-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"75e1b526-e0df-40c2-951f-9f64ce5e1bf2\",
                  [\"AT-40-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"e6ed511d-5c6e-48f5-a64b-01e517267e3d\",
                  [\"AT-41-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"ffa5d38f-5f44-4ec0-ad3b-5bc0417688a3\",
                  [\"AT-42-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"f1e8ac22-315d-4d1a-a8b5-11bd8b7b3c7f\",
                  [\"AT-43-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"5e943b52-fe79-4d53-bf16-5b7a4e3146fc\",
                  [\"AT-44-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"33a0106b-9f1a-45dd-bc3d-9773f87d3820\",
                  [\"AT-45-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"f9eae3a6-4052-4ebf-8c79-8e72811733cc\",
                  [\"AT-46-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"812dc165-ddc8-4318-b008-8833ff14d33e\",
                  [\"AT-47-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"4937316b-7228-4be8-9a16-30c5bc91364c\",
                  [\"AT-48-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"34d07d33-2a85-43d2-809e-1711507fa22c\",
                  [\"AT-49-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"a2e03560-2f5f-4520-8769-5380c7b47532\",
                  [\"AT-50-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"af7caf7e-39fb-4d1b-bcea-bc7cb44bf939\",
                  [\"AT-51-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"b3d94fc7-d9a0-4fb6-a91e-3c492729da90\",
                  [\"AT-52-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"d0ee44a0-86e1-4f30-bb44-1b2c0795734c\",
                  [\"AT-53-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"291da9ec-612b-434c-aeb5-d3833dcceddf\",
                  [\"AT-54-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"738fdd7a-5820-4981-8d6f-59c64f2e8740\",
                  [\"AT-55-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"98ece75e-2250-45ca-99e7-c55b4c894ee5\",
                  [\"AT-56-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"0825882e-863a-44cf-ac89-83189237ee6e\",
                  [\"AT-57-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"cf811300-ef77-4c34-b4fb-1899714e643a\",
                  [\"AT-58-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"01364957-0423-4331-bbea-f8b7451cca84\",
                  [\"AT-59-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"9b8abe7a-fa8b-4864-997d-b7f9e6ee7c86\",
                  [\"AT-60-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"f7887898-db0b-4408-a812-dd037884cbcf\",
                  [\"AT-61-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"9078924c-2511-4511-99ca-880e9c5da27c\",
                  [\"AT-62-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"2186ee87-738d-4513-ba67-c101390f9203\",
                  [\"AT-63-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"e8e279eb-64d2-439a-a57d-7987095af58c\",
                  [\"AT-64-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"fb0c2e88-e72f-43b3-99eb-ebc984cdfbd2\",
                  [\"AT-65-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"178074a4-63dc-432e-b9e3-f67349ef3bb0\",
                  [\"AT-66-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"153acbbd-cb8f-449b-9ffc-9bebe11811b9\",
                  [\"AT-67-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"7d2ae791-bed3-4537-b27c-9b34096c8fba\",
                  [\"AT-68-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"13602e30-cbd3-4987-b95b-116e9aeee859\",
                  [\"AT-69-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"ee0a829f-f11e-4f50-9c43-85e13e2519cd\",
                  [\"AT-70-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"d9a6a85b-412e-4c21-8eea-067c9b863445\",
                  [\"AT-71-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"3689a0f5-96ec-4a4a-a85a-e5c8d548dbcb\",
                  [\"AT-72-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"e052e2e2-4bb2-4c2b-a16d-92f358fde460\",
                  [\"AT-73-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"6b0c55ff-5105-42cc-b731-f5c6ea859751\",
                  [\"AT-74-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"b494950c-dc2b-4828-8471-238bfce2a214\",
                  [\"AT-75-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"165e8477-7104-45ac-8e49-c0a487820b3c\",
                  [\"AT-76-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"b32a0a92-ce6d-4e6f-b2b7-0341991a30fe\",
                  [\"AT-77-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"741d213a-e60f-445e-a9d9-8be984a1d892\",
                  [\"AT-78-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"8670afa9-d11d-4127-ad2d-ee120a273dab\",
                  [\"AT-79-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"538d6cc8-fe65-4e84-950e-96e2047778ea\",
                  [\"AT-80-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"9254ca76-da0c-4ece-bb52-ab2658903426\",
                  [\"AT-81-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"bab6dfff-f7a3-43c6-bf6c-4196da91c723\",
                  [\"AT-82-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"da09009b-0995-4627-951d-b0be526bfdae\",
                  [\"AT-83-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"b1bb1bcc-4dbb-42f1-81ad-6a49cfbc4752\",
                  [\"AT-84-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"5404ddcf-3b41-4e18-bf44-ab6c7574d387\",
                  [\"AT-85-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"13a73d3b-169c-479b-b3a5-74f3a8eab269\",
                  [\"AT-86-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"04475a63-8517-422d-b2d2-497a3eab3bf5\",
                  [\"AT-87-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"ca231ab6-784d-490f-b792-5babc8b4a5ae\",
                  [\"AT-88-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"6d5bebe7-73b0-4fb2-af4b-8375ef5ff3f5\",
                  [\"AT-89-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"1f1a9cd0-7fe1-468e-a594-bf9af5e7dc0d\",
                  [\"AT-90-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"6230d671-fedb-45b1-b2e4-e0fb9c897a64\",
                  [\"AT-91-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"278a7243-1f93-4a50-88a1-ab5b12470ab5\",
                  [\"AT-92-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"9ea8bd9a-5118-4947-a7af-488347e2f3fa\",
                  [\"AT-93-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"17097ae8-c8e4-4098-bd54-a158138f47a0\",
                  [\"AT-94-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"c88775c1-9d98-4e85-b603-ee0f538e2c4a\",
                  [\"AT-95-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"ef653a6b-b265-44ba-aaad-2d256f58bb26\",
                  [\"AT-96-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"1d6c418c-11a2-4e2f-a010-ff78f2f2fb91\",
                  [\"AT-97-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"2a32a73f-648b-4a2d-b87d-cd57d174d8c9\",
                  [\"AT-98-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"6103dac8-530b-4984-a1b2-303cba5cd4d3\",
                  [\"AT-99-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"cfb2021d-0fc5-4ed0-b926-adb8d6ac1ef1\",
                  [\"AT-100-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"ee3937de-d232-47ac-861d-a334893264d9\",
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

curl -H "X-API-KEY: $SEC_APISIX_ADMIN_KEY" -i "$END_POINT" -X PUT -d "$JSON_CONTENT"


echo -ne "\n\n"