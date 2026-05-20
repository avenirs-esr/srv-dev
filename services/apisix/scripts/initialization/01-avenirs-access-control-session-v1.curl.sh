#! /bin/sh

END_POINT="http://avenirs-apisix-api:9180/apisix/admin/plugin_configs"

JSON_CONTENT=$(cat <<EOF
{
  "id": "avenirs-access-control-session-v1",
  "desc": "Avenirs access control based on Spring session cookie and signed security context",
  "plugins": {
    "cors": {
      "_meta": {
        "disable": false
      },
      "allow_credential": true,
      "allow_headers": "Authorization,Content-Type,Accept,Origin,X-Requested-With,x-authorization",
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
          local cjson = require(\"cjson\")

          ngx.req.clear_header(\"X-Signed-Context\")
          ngx.req.clear_header(\"X-Context-Signature\")
          ngx.req.clear_header(\"X-Context-Kid\")
          ngx.req.clear_header(\"Authorization\")

          local cookie = ngx.var.http_cookie

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
            ngx.log(ngx.WARN, \"security context unauthorized with status \", res.status)

            return 401, {
              message = \"Unauthorized: invalid or expired session\",
              status = 401,
              code = \"UNAUTHORIZED\"
            }
          end

          if res.status ~= 200 then
            ngx.log(ngx.ERR, \"security context failed with status \", res.status)

            return 500, {
              message = \"Security context failed\",
              status = 500,
              code = \"SECURITY_CONTEXT_FAILED\"
            }
          end

          local ok, signed_context = pcall(cjson.decode, res.body or \"\")

          if not ok or signed_context == nil then
            ngx.log(ngx.ERR, \"invalid signed context response: \", res.body or \"\")

            return 500, {
              message = \"Invalid signed context response\",
              status = 500,
              code = \"INVALID_SIGNED_CONTEXT_RESPONSE\"
            }
          end

          if signed_context.payload == nil or signed_context.payload == \"\"
              or signed_context.signature == nil or signed_context.signature == \"\"
              or signed_context.kid == nil or signed_context.kid == \"\" then
            ngx.log(ngx.ERR, \"signed context response missing fields\")

            return 500, {
              message = \"Signed context response missing fields\",
              status = 500,
              code = \"SIGNED_CONTEXT_RESPONSE_MISSING_FIELDS\"
            }
          end

          core.request.set_header(ctx, \"X-Signed-Context\", signed_context.payload)
          core.request.set_header(ctx, \"X-Context-Signature\", signed_context.signature)
          core.request.set_header(ctx, \"X-Context-Kid\", signed_context.kid)

          ngx.req.clear_header(\"Cookie\")

          core.request.set_header(ctx, \"avenirsEndPoint\", ctx.var.uri)

          ngx.log(ngx.INFO, \"avenirs-access-control-session-v1 authenticated request\")

        end"
      ]
    }
  }
}
EOF
)

curl -H "X-API-KEY: $SEC_APISIX_ADMIN_KEY" -i "$END_POINT" -X PUT -d "$JSON_CONTENT"

echo -ne "\n\n"