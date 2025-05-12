#! /bin/bash

curl -H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1" -i "http://localhost/apisix-api/apisix/admin/routes" -X PUT -d '
{
  "name": "dynamic-upstream",
  "id": "dynupstrtmp",
  "uri": "/dynamic-upstream",
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
                ngx.log(ngx.ERR, \"serverless pre function token \", token);

                local httpc = http.new();
                local res, err = httpc:request_uri(\"http://avenirs-apache/node-api/select-upstream\", {
                
                    method = \"GET\",
                    headers = {
                        [\"Content-Type\"] = \"application/json\",
                        [\"x-authorization\"] = token
                    },
                    query={[\"foo\"] = \"bar\"}
                    -- body = core.request.get_body()

                });

                if res and res.body ~= nill 
                then 
                  local body = cjson.decode(res.body);
                  local upstream = body.upstream;
                  local endPoint = body.endPoint;
                  ngx.log(ngx.ERR, \"IN serverless pre function body \", inspect(body));
                  ngx.log(ngx.ERR, \"IN serverless pre function upstream \", upstream);
                  ngx.log(ngx.ERR, \"IN serverless pre function endPoint \", endPoint);

                  core.request.set_header(ctx, \"avenirsUpstream\", upstream);
                  core.request.set_header(ctx, \"avenirsEndPoint\", endPoint) ;
                else
                  ngx.log(ngx.ERR, \"Serverless error while trying to select the upstream: \", err);
                end  

            end"],
            "phase": "rewrite"
        },
        "proxy-rewrite": {
            "uri": "/$http_avenirsEndPoint"
        },
        "traffic-split": {
            "rules": [
                {
                    "match": [{
                        "vars": [[ "http_avenirsUpstream", "==", "univ1" ]]
                    }],
                    "weighted_upstreams": [{
                        "upstream": {
                            "name": "upstream_univ1",
                            "nodes": {
                                "avenirs-apache:80": 1
                            },
                            "type": "roundrobin"
                        }
                    }]
                },
                 {
                    "match": [{
                        "vars": [[ "http_avenirsUpstream", "==", "univ2" ]]
                    }],
                    "weighted_upstreams": [{
                        "upstream": {
                            "name": "upstream_univ2",
                            "nodes": {
                                "avenirs-node:3000": 1
                            },
                            "type": "roundrobin"
                        }
                    }]
                }
            ]
        }
    },
  
    "upstream": {
    "type": "roundrobin",
    "nodes": {
      "avenirs-apache": 1
    }
  }
}'
