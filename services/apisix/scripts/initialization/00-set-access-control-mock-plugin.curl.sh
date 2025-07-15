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
                  [\"AT-1-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"7bb3b40f-d677-4a84-b222-f5d64672f5fb\",
                  [\"AT-2-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"b5216586-0aee-4c39-ac43-423ef46774e3\",
                  [\"AT-3-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"c4e5b625-04c9-4474-adf7-5f47d7d93b3f\",
                  [\"AT-4-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"6aae228d-e5f9-4179-8401-ae8b67ae332a\",
                  [\"AT-5-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"8664e527-b1c4-450e-94e8-a73dfaaa1a34\",
                  [\"AT-6-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"1defa69c-8f5f-44fb-aed9-4328cd7b259d\",
                  [\"AT-7-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"2ca41277-a508-4bd3-81a7-1b6c781e4b48\",
                  [\"AT-8-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"d96dce06-5e90-4af1-8987-73eea5636e5e\",
                  [\"AT-9-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"09dea2e1-2ee3-4071-91db-2589ebe5a114\",
                  [\"AT-10-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"1a10fd97-30ad-4309-8e82-2901cc47dbd2\",
                  [\"AT-11-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"e77b0c52-25e3-44f6-9623-9419ab20f1b3\",
                  [\"AT-12-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"0d1fa4b4-74a2-4924-864e-8033470cf09f\",
                  [\"AT-13-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"a68e849c-f0c5-470c-acc7-016182dc2760\",
                  [\"AT-14-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"ee0e9e54-867e-42c3-a0ac-d38ec74280b8\",
                  [\"AT-15-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"485fc7d4-29b9-4139-b2bc-29b5cd014d16\",
                  [\"AT-16-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"c9580fc9-6afa-4a71-96b1-e0143a33ea19\",
                  [\"AT-17-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"f09d44f3-5578-4e99-8a88-129f3f867df7\",
                  [\"AT-18-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"51db9407-e906-442e-bbea-1ec02f8fc2a0\",
                  [\"AT-19-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"a98076a9-bca9-4707-9462-d9e363fc36c7\",
                  [\"AT-20-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"6ac1e58c-c4c5-464c-b12a-aaa93bfef5a7\",
                  [\"AT-21-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"2e789fdb-9d33-40f3-ae16-e8bb36c20385\",
                  [\"AT-22-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"22084cd7-c05c-4123-942e-6f57d77e1a59\",
                  [\"AT-23-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"8a9bad2f-1b52-4d20-84d4-70e7b68d756a\",
                  [\"AT-24-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"80b5c186-42c1-4e83-861c-567c2093df18\",
                  [\"AT-25-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"727f837c-84ac-459a-b033-e583b210f8ba\",
                  [\"AT-26-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"518c63c0-295b-4c31-bc08-5bcec7c161c1\",
                  [\"AT-27-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"d66bfc67-4506-418b-aec4-25b60f545dae\",
                  [\"AT-28-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"c137ef5e-91a7-4788-af08-c6a9c257d3e9\",
                  [\"AT-29-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"79e51f6c-445e-4962-8482-2ff91e381cfe\",
                  [\"AT-30-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"d4387b37-3e29-4d69-b804-be25d9b75da6\",
                  [\"AT-31-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"ac7f27cd-28b5-4c96-b8cb-a396f5c27764\",
                  [\"AT-32-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"5e3b7b03-02e4-4bf1-b340-9aec3796f14f\",
                  [\"AT-33-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"95ecb394-950d-4b0d-b2ed-005a67b10559\",
                  [\"AT-34-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"869e9ffb-df59-4f03-b005-e32a1f94620c\",
                  [\"AT-35-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"d5c56269-6e59-48fa-b359-2476efec8bff\",
                  [\"AT-36-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"4082b68a-7e17-44d4-80b3-49d716759fb1\",
                  [\"AT-37-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"845b3349-04ae-423b-a250-1df7d76458c2\",
                  [\"AT-38-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"908680fe-d049-4be4-8a60-37628459a119\",
                  [\"AT-39-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"44a73dca-4704-401d-86ca-487bb4982cfe\",
                  [\"AT-40-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"49e0de7c-8581-4236-b4cd-581155ec28e6\",
                  [\"AT-41-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"631ea00d-d3c6-4ffd-b575-c48d49d5897e\",
                  [\"AT-42-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"2702f688-9780-4e77-a560-840c3ebcab65\",
                  [\"AT-43-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"240bdcc3-8c2b-4053-926d-56d0ca6e10c1\",
                  [\"AT-44-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"eeb98b74-c9f4-408f-91de-02e9981da6e6\",
                  [\"AT-45-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"9f32a39b-ca5c-49b1-a165-4db809cd2974\",
                  [\"AT-46-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"3c19de7d-69ca-438c-83a3-16d4dd74d8a4\",
                  [\"AT-47-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"d5cfc9f9-b3a0-4308-919e-392558e80635\",
                  [\"AT-48-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"abecb8ee-11c7-4c9a-94c9-dca335eeca56\",
                  [\"AT-49-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"efbaec32-2c16-4b7d-bef6-fbd3bfab93ff\",
                  [\"AT-50-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"0c9762d1-8dc0-4d7c-a55a-cef4bad51223\",
                  [\"AT-51-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"e742b708-c62a-4043-8599-ac3d9650448e\",
                  [\"AT-52-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"10f0be98-dbe8-48f5-94ee-ec0625e80c9f\",
                  [\"AT-53-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"5e8563b2-55ae-409d-84f4-807ed9ed2caf\",
                  [\"AT-54-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"b95ee7d1-ae7a-4af9-97d6-d0a88a307257\",
                  [\"AT-55-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"8f432690-ac87-4595-bd7a-17979f12b566\",
                  [\"AT-56-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"bf50e78e-693f-4a72-9ec5-74152acf9d4e\",
                  [\"AT-57-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"3bd92b64-46f3-4118-b325-ffb3cc478ddd\",
                  [\"AT-58-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"5b97bc26-2b57-488d-a1c1-3ad6a6265841\",
                  [\"AT-59-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"b08510d9-ab81-44e8-b2d2-795e0c8d594f\",
                  [\"AT-60-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"ac40b62e-468b-4193-8e52-563d465cba2c\",
                  [\"AT-61-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"cb3ef819-afd8-4b01-864c-be540be704d5\",
                  [\"AT-62-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"63cd70c0-ec94-412d-b19c-1d59b31b9330\",
                  [\"AT-63-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"b63ed101-38f6-4fe6-b028-b799aae843d7\",
                  [\"AT-64-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"4b366581-9834-4b58-8726-74ceff92eac0\",
                  [\"AT-65-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"3aeb8887-02e5-4283-80d8-4d6827ed3e9b\",
                  [\"AT-66-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"0568c1c8-d79b-45a3-a3e7-f0f1ed419e99\",
                  [\"AT-67-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"b8cfef3b-ea23-4285-8951-5493ec8390e4\",
                  [\"AT-68-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"6c174352-4e98-4391-8021-1b56a8fef788\",
                  [\"AT-69-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"930ce69b-3b56-42c0-9832-99f1228eda76\",
                  [\"AT-70-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"9ecbbff4-7acc-489c-a885-7c2cba92ef50\",
                  [\"AT-71-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"e6a9d9f2-8cf3-4507-95a3-ebe84d849c8a\",
                  [\"AT-72-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"012628d6-3c43-4681-97ce-64b2c366573f\",
                  [\"AT-73-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"33b5d752-7f15-4241-b203-ae659aeed03c\",
                  [\"AT-74-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"efb13e39-9040-4d4b-90b3-94e282701441\",
                  [\"AT-75-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"3abd1042-544e-4229-b5f0-25bb6f673f0f\",
                  [\"AT-76-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"77d2cbc9-26dc-4640-a86d-d82cbd2e78b6\",
                  [\"AT-77-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"aa6fa1af-cf15-40ca-800c-dc78333bddcc\",
                  [\"AT-78-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"224f1e68-6d28-434e-9b91-d1bb0ef909f8\",
                  [\"AT-79-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"87f367b4-3f10-4bf3-b97e-a487ee694f9c\",
                  [\"AT-80-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"d289f712-985d-429b-b69a-1ccb849a13d8\",
                  [\"AT-81-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"0113d892-989f-4fa3-98ea-4ef975d5eb8b\",
                  [\"AT-82-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"e9547211-b3f9-4f05-a94e-b3d950692638\",
                  [\"AT-83-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"0a6cdf80-4035-49ea-b122-abb048e17aeb\",
                  [\"AT-84-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"b48b1974-0498-4035-bc59-741715808380\",
                  [\"AT-85-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"86dfa28f-1069-4d85-8ad3-061b8cb7d989\",
                  [\"AT-86-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"f665d6ed-4f03-41ed-81b7-4cddec112e04\",
                  [\"AT-87-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"45619b86-a0d9-452b-a6c8-3a6031f95e21\",
                  [\"AT-88-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"4142eb8f-eb86-4f1d-9428-43faa1c75bbe\",
                  [\"AT-89-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"a1bca8fa-0330-4157-aa66-f8d036b3e5dc\",
                  [\"AT-90-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"734008ce-6a18-43f9-9d0c-c60af7b8f5a8\",
                  [\"AT-91-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"775df44d-d893-4156-81e3-35a4bf579675\",
                  [\"AT-92-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"c4929dea-fa3f-443e-8918-354cf0ca5877\",
                  [\"AT-93-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"3bee8e8f-3c98-4d06-97cc-7aee46bdef4d\",
                  [\"AT-94-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"cec74fe2-9196-46d1-9ecd-dd62b097d57b\",
                  [\"AT-95-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"f2ec39c4-9608-44f7-ad50-6d69c2537eb7\",
                  [\"AT-96-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"d5329ae6-3169-4db3-9966-9671489bdcda\",
                  [\"AT-97-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"a0f6cf70-c39e-4269-ab13-f942cff3a61f\",
                  [\"AT-98-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"015d395f-c662-4756-b645-2f9fc24c85dd\",
                  [\"AT-99-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"7557eff7-6021-485a-92f2-564ba64d6175\",
                  [\"AT-100-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"83a81100-68a2-4478-8791-6756b5f2ac13\",
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