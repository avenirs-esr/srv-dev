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
                  [\"AT-1-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"f2673d3c-0789-46f0-bd06-446c4e6d010c\",
                  [\"AT-2-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"ef1f47dd-7de3-4e9a-adf7-fadd70f4dec4\",
                  [\"AT-3-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"91f26fee-9ee8-4ae8-9322-2c50724d4a4a\",
                  [\"AT-4-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"d0947d74-aed3-444d-bf3d-2da16320338e\",
                  [\"AT-5-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"00e4fee0-4fb9-4c7a-8409-d48eb70a00b1\",
                  [\"AT-6-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"49d39b25-fa55-4d8f-8edc-461707e8c308\",
                  [\"AT-7-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"12ad710e-a18c-4f68-9696-47c4ea29f211\",
                  [\"AT-8-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"9c6c4b93-20cc-4571-a9d2-6dfad087ef84\",
                  [\"AT-9-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"68c2cfbd-2ef3-48c8-b040-cc7750ead252\",
                  [\"AT-10-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"ab205168-006b-40ae-855c-92349cf400ad\",
                  [\"AT-11-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"cd31e9c3-96ff-480e-963f-1ef5beff8f4a\",
                  [\"AT-12-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"d70d1448-a959-4e7e-86f6-26e10debd2b1\",
                  [\"AT-13-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"4b687d48-9cde-4b2e-832d-bc58be4d1e8e\",
                  [\"AT-14-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"44139402-8a4a-4e7b-806e-9d7d5a7252af\",
                  [\"AT-15-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"62094ca1-e7af-42d3-a6b0-05e27ec76b6a\",
                  [\"AT-16-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"57ab7c90-57bd-4a08-856f-d47535846664\",
                  [\"AT-17-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"981460ca-38b1-45da-bf39-761af369d105\",
                  [\"AT-18-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"b2231dbf-7567-4821-9730-5db436ab85ba\",
                  [\"AT-19-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"93d78036-318c-47ee-8560-15b7c0277198\",
                  [\"AT-20-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"c6728056-7fc6-423c-ad2f-16d888935007\",
                  [\"AT-21-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"080b984c-a92e-4023-8bb3-d4f02335f66f\",
                  [\"AT-22-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"6edde382-5d19-4106-a03d-d1f95b494f95\",
                  [\"AT-23-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"a6853587-7109-41ec-8bc3-402e4a15f7fe\",
                  [\"AT-24-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"1bda71a8-7119-4ebf-ac84-5b7f7407c932\",
                  [\"AT-25-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"c56246a4-58e1-49db-be23-fc015ce349f4\",
                  [\"AT-26-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"a6c19b93-43b9-4fa6-a739-37911ca0ce12\",
                  [\"AT-27-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"5553cad0-766e-4eb5-ba1b-29c766b866b4\",
                  [\"AT-28-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"1aae3b33-3c82-469b-84f5-305ac541c333\",
                  [\"AT-29-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"c32bbc3b-79a2-4dae-8f92-d8a6dee070b1\",
                  [\"AT-30-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"3fdb81ed-dfc3-421c-a3b5-93e425119f81\",
                  [\"AT-31-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"d7750771-2a6e-47c2-981c-5a90bf1619f8\",
                  [\"AT-32-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"6e28a96f-d64f-4a27-aafe-f6b52cae9255\",
                  [\"AT-33-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"d7e0ae2a-fd9f-4d68-a7cf-33e23a443d4c\",
                  [\"AT-34-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"a7f846bb-b453-4734-92cb-46fb0b508692\",
                  [\"AT-35-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"1ab38efd-8f9f-43a8-85d7-51a1f7298b1c\",
                  [\"AT-36-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"955ca670-fdca-4c5f-81ef-dc84cbcbb8b1\",
                  [\"AT-37-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"abbc1814-0ce3-47c7-a154-cb1c27900801\",
                  [\"AT-38-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"32960e19-681c-4254-9941-aa05ef0fec73\",
                  [\"AT-39-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"ebff8a56-36fe-4164-8eeb-b2e1eaf44cf9\",
                  [\"AT-40-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"1ae26e97-5f9d-469a-9472-d1b10982f379\",
                  [\"AT-41-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"8a07542c-d708-4f02-8f19-fc2f7d5ea17f\",
                  [\"AT-42-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"8d02bbbf-a98f-4db6-875b-ddbda6fe546c\",
                  [\"AT-43-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"fc9c7fac-cca6-4e13-ab19-8b8abf303ef7\",
                  [\"AT-44-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"a85dcd48-47b5-4c63-bbaf-24e3307279ee\",
                  [\"AT-45-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"69431ad9-3ce7-4328-81bf-b5b0df5d1d0e\",
                  [\"AT-46-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"48eab2c0-875b-4705-8821-9d31cd83c70a\",
                  [\"AT-47-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"f4e1baa3-c317-4e0e-b8b4-147e1be8b3c7\",
                  [\"AT-48-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"a35295c1-4960-4f88-82a6-131a6ae1d72d\",
                  [\"AT-49-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"4eb5ec6e-95cb-481d-b7fd-0174de7ddd43\",
                  [\"AT-50-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"e51ce1e4-e4ce-483e-9569-49bd87f56dfb\",
                  [\"AT-51-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"481702f3-e04e-4602-9c26-ea6f16415306\",
                  [\"AT-52-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"2dbe161b-fb9c-45dd-81a0-070d13e76d7f\",
                  [\"AT-53-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"63d2fd9a-1c2f-4877-b889-88e94a9fdb8b\",
                  [\"AT-54-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"eeb98b74-c9f4-408f-91de-02e9981da6e6\",
                  [\"AT-55-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"ddf1d024-0691-403e-80ee-f22958882beb\",
                  [\"AT-56-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"b09be28c-7075-402d-9ce0-0fa395e0b666\",
                  [\"AT-57-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"d587194a-7819-477e-b949-ce32b8f89511\",
                  [\"AT-58-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"b14d997b-4197-4d7a-b767-e2fdac59bcc2\",
                  [\"AT-59-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"e3521375-05ec-4f4e-a1c7-b05f91b2182b\",
                  [\"AT-60-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"63d46637-8a63-4c92-8778-485c28a8b47c\",
                  [\"AT-61-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"d3c10f4c-a19c-4310-a637-2fa72c74f275\",
                  [\"AT-62-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"ec8de6b0-0ad1-4492-afbd-7976ce801c5c\",
                  [\"AT-63-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"a3de2ad5-cdfe-4dce-9c0d-824a94218566\",
                  [\"AT-64-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"cafee6b8-1cb0-4573-8828-6403033c8b0f\",
                  [\"AT-65-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"7dc61409-c788-48bc-8e15-5885565e7db0\",
                  [\"AT-66-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"54155757-1d5d-480b-a93d-5d634e573f5c\",
                  [\"AT-67-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"7a328c16-4991-484a-9219-60d55075581e\",
                  [\"AT-68-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"71a30fbd-3ccb-4654-ba69-40ae6e99188f\",
                  [\"AT-69-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"cefcb254-7773-450d-bab0-9be5389ce095\",
                  [\"AT-70-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"045f8a7b-bb1e-4e03-ad64-d9da3dd47ed1\",
                  [\"AT-71-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"59c7c966-642d-44cb-a0ce-9da03ef429fe\",
                  [\"AT-72-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"d4c8f6c8-1eea-4dfc-8be1-0186ce2e13de\",
                  [\"AT-73-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"24dd6335-8ae1-47f7-8da9-671da4ed3735\",
                  [\"AT-74-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"7437c7d2-ada2-4cd9-980f-3fdd9e20cd0f\",
                  [\"AT-75-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"b5b7b222-c26c-46d9-864c-a8684a065af8\",
                  [\"AT-76-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"97c79442-b1be-4a55-9aa0-236b5ae5f1f7\",
                  [\"AT-77-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"249c6663-ec09-414d-888a-5922e34147ce\",
                  [\"AT-78-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"f2208738-4e79-4168-af60-6e8455828385\",
                  [\"AT-79-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"d4ea3de7-0d35-45a1-9f1c-1edd655bcb65\",
                  [\"AT-80-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"f2303f5b-77e1-46b8-a3ab-6d449c72d85e\",
                  [\"AT-81-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"0b6942a6-b352-4b14-b846-1b309040a8f6\",
                  [\"AT-82-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"dc2ad637-c746-41be-96fc-f84a7482e76a\",
                  [\"AT-83-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"9a0f8634-9c8e-4a45-a649-02f1e498c6a2\",
                  [\"AT-84-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"f1399cb0-dc6d-468b-a69f-50d718d4a7ff\",
                  [\"AT-85-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"98d0fa29-2e4d-4d5d-9efa-b2bbf1674756\",
                  [\"AT-86-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"a01cc633-07b7-4b88-bf26-1f763704c0b2\",
                  [\"AT-87-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"4739d8e7-9b1a-4973-90f9-51ab4682cd34\",
                  [\"AT-88-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"187ae411-d2d2-4190-be4c-123e236459ed\",
                  [\"AT-89-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"a7196092-184b-4587-9cd4-6418cbdc1946\",
                  [\"AT-90-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"719b489b-2018-47bf-bfeb-927f9375f6d9\",
                  [\"AT-91-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"2aa10360-674b-4635-a3bd-11569fa1b6ae\",
                  [\"AT-92-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"d0988bbd-efcc-4867-a09f-579447f5b696\",
                  [\"AT-93-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"3285bc28-4490-4240-ab21-db1ef4d89194\",
                  [\"AT-94-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"eba71275-9b17-4a3f-acad-698b15803a73\",
                  [\"AT-95-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"a0528217-0800-4341-9acb-9aecf982b440\",
                  [\"AT-96-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"120c99cb-e9c1-4aa1-9327-b65930834b75\",
                  [\"AT-97-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"eec9be9f-8568-48b8-a972-d3bae2e3fab8\",
                  [\"AT-98-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"4a7282d9-1811-4a07-90d0-bad7078785a4\",
                  [\"AT-99-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"4c076a8e-3c96-42be-8103-6c3cad23639b\",
                  [\"AT-100-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"68529f38-07b0-4a73-a183-21c26b9c0208\",
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