#! /bin/bash

END_POINT="http://localhost/apisix-api/apisix/admin/plugin_configs"

[ "$1" = "-d" -o "$1" = "--srv-dev" ] \
&& { END_POINT="http://srv-dev-avenir.srv-avenir.brgm.recia.net/apisix-api/apisix/admin/plugin_configs"; shift; } 
echo -ne "\nUsing end point: $END_POINT\n\n"



curl -H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1" -i "$END_POINT" -X PUT -d '
{
  "id": "avenirs-access-control",
  "desc": "Avenirs access control based on openid-connect and serveless-pre-function",
    "plugins": {
        "openid-connect": {
          
          "bearer_only": true,
          "client_id": "APIMClientId",
          "client_secret": "ErT322hVLHzIi9Z5tbu58yzUvzVqlsh3T0tmKRV41bu004wqY664TM=",
          "discovery": "https://avenirs-apache/cas/oidc/.well-known",
          "introspection_endpoint": "https://avenirs-apache/cas/oidc/introspect",
          "redirect_uri": "https://httpbin.org",
          "scope": "openid profile email",
          "set_access_token_header": true,
          "token_endpoint_auth_method": "GET"
        
        },
        "serverless-pre-function": {
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

                local masked_token = string.sub(token, 1, 4) .. string.rep(\"*\", math.max(0, #token - 4))
                local method = core.request.get_method(ctx);
                local resource = ctx.var.arg_resource;
                local uri=ctx.var.uri

                ngx.log(ngx.ERR, \"serverless pre function token \", masked_token)
                ngx.log(ngx.ERR, \"serverless pre uri \", uri)
                ngx.log(ngx.ERR, \"serverless pre method \", method)
                
                if resource == nill 
                then
                  resource = ctx.var.post_arg_resource;
                end

                ngx.log(ngx.ERR, \"IN serverless pre function resource \", resource);
                local httpc = http.new();
                local res, err = httpc:request_uri(\"http://avenirs-apache/avenirs-portfolio-security/access-control/authorize\", {
                
                    method = \"GET\",
                    headers = {
                        [\"Content-Type\"] = \"application/json\",
                        [\"x-authorization\"] = token
                    },
                    query={
                      [\"uri\"] =  uri,
                      [\"resource\"] = resource,
                      [\"method\"] = method
                    }
                });

                if res and res.body ~= nill 
                then 
                  ngx.log(ngx.ERR, \"IN serverless pre function res.body \", res.body);
                  local body = cjson.decode(res.body);
                  local upstream = body.upstream;
                  local endPoint = body.endPoint;
                  ngx.log(ngx.ERR, \"IN serverless pre function body \", inspect(body));
                  ngx.log(ngx.ERR, \"IN serverless pre function body.granted \", body.granted);

                   if body.granted
                   then
                      ngx.log(ngx.ERR, \"Granted\", inspect(body));
                    else
                      ngx.log(ngx.ERR, \"Not granted \", inspect(body));
                      return 401, \"Access not granted\"
                    end
                  core.request.set_header(ctx, \"avenirsEndPoint\",\"node-api/\"..ctx.var.uri) ;
                else
                  ngx.log(ngx.ERR, \"Serverless error while trying to check access control: \", err);
                end  
            end"],
            "phase": "rewrite"
        },
        "proxy-rewrite": {
            "uri": "/$http_avenirsEndPoint"
        }
    }
  
}'


echo -ne "\n\n"