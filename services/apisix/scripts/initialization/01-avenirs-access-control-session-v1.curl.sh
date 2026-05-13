#! /bin/sh

END_POINT="http://avenirs-apisix-api:9180/apisix/admin/plugin_configs"

JSON_CONTENT=$(cat <<EOF
{
  "id": "avenirs-access-control-session-v1",
  "desc": "Avenirs access control based on Spring session cookie and security context",
  "plugins": {
    "cors": {
      "_meta": {
        "disable": false
      },
      "allow_credential": true,
      "allow_headers": "Authorization,Content-Type,Accept,Origin,X-Requested-With,x-authorization,x-signed-context,x-context-signature,x-context-kid",
      "allow_methods": "GET,POST,PUT,PATCH,DELETE,OPTIONS",
      "allow_origins": "http://localhost:5173,https://dev.avenirs-esr.fr,https://qualif.avenirs-esr.fr,https://recette.avenirs-esr.fr",
      "expose_headers": "Content-Disposition",
      "max_age": 3600
    },
    "proxy-rewrite": {
      "regex_uri": ["^/_v1(.*)", "\$1"]
    },
    "serverless-pre-function": {
      "phase": "rewrite",
      "functions": [
        "return function(conf, ctx)

          if ctx.var.request_method == \"OPTIONS\" then
            return
          end

          local core = require(\"apisix.core\")
          local http = require(\"resty.http\")
          local hmac = require(\"resty.hmac\")
          local cjson = require(\"cjson\")

          ngx.log(ngx.INFO, \"avenirs-access-control-session-v1 start\")

          local cookie = core.request.header(ctx, \"Cookie\")

          if cookie == nil or cookie == \"\" then
            return 401, {
              message = \"Unauthorized: missing session cookie\",
              status = 401,
              code = \"UNAUTHORIZED\"
            }
          end

          local httpc = http.new()
          httpc:set_timeout(5000)

          local res, err = httpc:request_uri(
            \"http://avenirs-portfolio-security:12000/internal/auth/context\",
            {
              method = \"GET\",
              headers = {
                [\"Cookie\"] = cookie,
                [\"Accept\"] = \"application/json\",
                [\"X-Forwarded-Host\"] = core.request.header(ctx, \"X-Forwarded-Host\") or \"dev.avenirs-esr.fr\",
                [\"X-Forwarded-Proto\"] = core.request.header(ctx, \"X-Forwarded-Proto\") or \"https\",
                [\"X-Forwarded-Port\"] = core.request.header(ctx, \"X-Forwarded-Port\") or \"443\"
              },
              keepalive = false
            }
          )

          if not res then
            ngx.log(ngx.ERR, \"security context unavailable: \", err or \"unknown error\")

            return 503, {
              message = \"Security service unavailable\",
              status = 503,
              code = \"SECURITY_UNAVAILABLE\"
            }
          end

          if res.status == 401 or res.status == 403 then
            ngx.log(ngx.WARN, \"security context unauthorized with status \", res.status, \" body \", res.body or \"\")

            return 401, {
              message = \"Unauthorized: invalid or expired session\",
              status = 401,
              code = \"UNAUTHORIZED\"
            }
          end

          if res.status ~= 200 then
            ngx.log(ngx.ERR, \"security context failed with status \", res.status, \" body \", res.body or \"\")

            return 500, {
              message = \"Security context failed\",
              status = 500,
              code = \"SECURITY_CONTEXT_FAILED\"
            }
          end

          local ok, auth_context = pcall(cjson.decode, res.body or \"\")

          if not ok or auth_context == nil then
            ngx.log(ngx.ERR, \"invalid security context response: \", res.body or \"\")

            return 500, {
              message = \"Invalid security context response\",
              status = 500,
              code = \"INVALID_SECURITY_CONTEXT_RESPONSE\"
            }
          end

          if auth_context.authenticated ~= true then
            return 401, {
              message = \"Unauthorized: unauthenticated session\",
              status = 401,
              code = \"UNAUTHORIZED\"
            }
          end

          local now = ngx.time()

          local user_context = {
            sub = auth_context.userId or auth_context.sub,
            userId = auth_context.userId,
            principalId = auth_context.principalId,
            login = auth_context.login,
            iat = now,
            exp = now + 300
          }

          if user_context.sub == nil or user_context.sub == \"\" then
            ngx.log(ngx.ERR, \"security context missing userId/sub: \", res.body or \"\")

            return 500, {
              message = \"Security context missing user identifier\",
              status = 500,
              code = \"SECURITY_CONTEXT_MISSING_USER_IDENTIFIER\"
            }
          end

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
          ngx.req.clear_header(\"Cookie\")

          core.request.set_header(ctx, \"avenirsEndPoint\", ctx.var.uri)

          ngx.log(ngx.INFO, \"avenirs-access-control-session-v1 authenticated user \", user_context.sub)

        end"
      ]
    }
  }
}
EOF
)

curl -H "X-API-KEY: $SEC_APISIX_ADMIN_KEY" -i "$END_POINT" -X PUT -d "$JSON_CONTENT"

echo -ne "\n\n"