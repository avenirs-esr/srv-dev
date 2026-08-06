#! /bin/sh

END_POINT="http://avenirs-apisix-api:9180/apisix/admin/plugin_configs"


JSON_CONTENT=$(cat <<EOF
{
  "id": "avenirs-access-control-mock",
  "desc": "Avenirs access control mock based on serveless-pre-function",
  "plugins": {
    "cors": {
      "_meta": {
        "disable": false
      },
      "allow_credential": true,
      "allow_headers": "Authorization,Content-Type,Accept,Origin,X-Requested-With,x-authorization,x-signed-context",
      "allow_methods": "GET,POST,PUT,PATCH,DELETE,OPTIONS",
      "allow_origins": "http://localhost:5173,http://localhost:4173,https://dev.avenirs-esr.fr,https://qualif.avenirs-esr.fr,https://recette.avenirs-esr.fr",
      "expose_headers": "Content-Disposition",
      "max_age": 3600
    },
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
                  [\"AT-1-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"lucas.tessier@university.com\",
                  [\"AT-2-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"arthur.lambert@university.com\",
                  [\"AT-3-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"sophie.charpentier@university.com\",
                  [\"AT-4-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"ethan.perrin@university.com\",
                  [\"AT-5-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"camille.fournier@university.com\",
                  [\"AT-6-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"anais.marchand@university.com\",
                  [\"AT-7-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"valentin.favre@university.com\",
                  [\"AT-8-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"lina.boucher@university.com\",
                  [\"AT-9-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"jules.carpentier@university.com\",
                  [\"AT-10-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"eva.lamy@university.com\",
                  [\"AT-11-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"martin.fabre@university.com\",
                  [\"AT-12-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"zoe.cousin@university.com\",
                  [\"AT-13-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"noah.lefebvre@university.com\",
                  [\"AT-14-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"aya.paris@university.com\",
                  [\"AT-15-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"tom.renaud@university.com\",
                  [\"AT-16-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"sarah.baron@university.com\",
                  [\"AT-17-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"lea.richard@university.com\",
                  [\"AT-18-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"adam.hubert@university.com\",
                  [\"AT-19-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"emma.gaillard@university.com\",
                  [\"AT-20-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"hugo.mahe@university.com\",
                  [\"AT-21-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"chloe.lebrun@university.com\",
                  [\"AT-22-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"louis.arnaud@university.com\",
                  [\"AT-23-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"ines.blanc@university.com\",
                  [\"AT-24-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"nathan.rolland@university.com\",
                  [\"AT-25-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"manon.hoareau@university.com\",
                  [\"AT-26-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"alex.poirier@university.com\",
                  [\"AT-27-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"julie.teixeira@university.com\",
                  [\"AT-28-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"maxime.grondin@university.com\",
                  [\"AT-29-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"paul.lemoine@university.com\",
                  [\"AT-30-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"clara.renault@university.com\",
                  [\"AT-31-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"baptiste.royer@university.com\",
                  [\"AT-32-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"ines.barre@university.com\",
                  [\"AT-33-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"alexandre.perret@university.com\",
                  [\"AT-34-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"marine.carlier@university.com\",
                  [\"AT-35-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"yaniss.rodier@university.com\",
                  [\"AT-36-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"maya.peltier@university.com\",
                  [\"AT-37-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"olivier.bodin@university.com\",
                  [\"AT-38-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"salome.thierry@university.com\",
                  [\"AT-39-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"timeo.bertin@university.com\",
                  [\"AT-40-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"giulia.laporte@university.com\",
                  [\"AT-41-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"malo.riviere@university.com\",
                  [\"AT-42-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"elisa.monnier@university.com\",
                  [\"AT-43-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"mathis.descamps@university.com\",
                  [\"AT-44-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"camille.delorme@university.com\",
                  [\"AT-45-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"thelma.normand@university.com\",
                  [\"AT-46-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"noah.maury@university.com\",
                  [\"AT-47-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"louna.barreau@university.com\",
                  [\"AT-48-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"leo.ledoux@university.com\",
                  [\"AT-49-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"ambre.becker@university.com\",
                  [\"AT-50-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"oscar.mary@university.com\",
                  [\"AT-51-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"agathe.peron@university.com\",
                  [\"AT-52-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"sami.barbier@university.com\",
                  [\"AT-53-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"elodie.chretien@university.com\",
                  [\"AT-54-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"evan.raynaud@university.com\",
                  [\"AT-55-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"helena.weber@university.com\",
                  [\"AT-56-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"simon.roy@university.com\",
                  [\"AT-57-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"nina.philippe@university.com\",
                  [\"AT-58-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"ilian.gilbert@university.com\",
                  [\"AT-59-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"axel.poulain@university.com\",
                  [\"AT-60-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"jade.caillet@university.com\",
                  [\"AT-61-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"david.camus@university.com\",
                  [\"AT-62-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"lise.bonneau@university.com\",
                  [\"AT-63-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"yanis.prevost@university.com\",
                  [\"AT-64-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"lola.brunet@university.com\",
                  [\"AT-65-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"ismael.aubert@university.com\",
                  [\"AT-66-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"eline.guillot@university.com\",
                  [\"AT-67-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"leo.blot@university.com\",
                  [\"AT-68-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"nour.denis@university.com\",
                  [\"AT-69-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"alicia.navarro@university.com\",
                  [\"AT-70-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"mael.masson@university.com\",
                  [\"AT-71-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"louise.lacombe@university.com\",
                  [\"AT-72-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"victor.schmitt@university.com\",
                  [\"AT-73-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"anael.hardy@university.com\",
                  [\"AT-74-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"sofia.godard@university.com\",
                  [\"AT-75-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"nolan.guichard@university.com\",
                  [\"AT-76-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"mila.bruneau@university.com\",
                  [\"AT-77-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"ilyes.lapeyre@university.com\",
                  [\"AT-78-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"romy.launay@university.com\",
                  [\"AT-79-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"iris.barre@university.com\",
                  [\"AT-80-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"maelys.descartes@university.com\",
                  [\"AT-81-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"elias.langlois@university.com\",
                  [\"AT-82-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"mya.jacquet@university.com\",
                  [\"AT-83-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"owen.parent@university.com\",
                  [\"AT-84-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"nora.thiery@university.com\",
                  [\"AT-85-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"idriss.pineau@university.com\",
                  [\"AT-86-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"lila.daniel@university.com\",
                  [\"AT-87-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"eden.perrault@university.com\",
                  [\"AT-88-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"talia.hoquet@university.com\",
                  [\"AT-89-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"marin.legendre@university.com\",
                  [\"AT-90-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"nils.chauvet@university.com\",
                  [\"AT-91-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"ava.perrot@university.com\",
                  [\"AT-92-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"titouan.savary@university.com\",
                  [\"AT-93-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"dorian.poulain@university.com\",
                  [\"AT-94-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"jenna.marchal@university.com\",
                  [\"AT-95-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"ali.meunier@university.com\",
                  [\"AT-96-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"selena.pineau@university.com\",
                  [\"AT-97-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"ilan.picard@university.com\",
                  [\"AT-98-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"maud.bonnard@university.com\",
                  [\"AT-99-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"kenzo.roche@university.com\",
                  [\"AT-100-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r\"] = \"aya.germain@university.com\",
                }

                -- Mock mode: grant every known permission so local/dev testing
                -- never gets blocked by authorization checks.
                local mock_authorities = {
                  \"profile:read:own\", \"profile:update:own\",
                  \"trace:create:own\", \"trace:list:own\", \"trace:read:contextual\",
                  \"trace:download:contextual\", \"trace:association:manage:own\",
                  \"competency:read\",
                  \"declared-skill:list:own\", \"declared-skill:create:own\",
                  \"declared-skill:update:own\", \"declared-skill:delete:own\",
                  \"declared-skill:association:manage:own\",
                  \"declared-experience:list:own\", \"declared-experience:create:own\",
                  \"declared-experience:delete:own\", \"declared-experience:association:manage:own\",
                  \"activity:catalog:read:contextual\", \"activity:register:own\",
                  \"activity:read:contextual\", \"activity:document:download:contextual\",
                  \"activity:document:read:contextual\", \"employment-kit:read:own\",
                  \"activity:library:staff:read\", \"activity:national:create\",
                  \"activity:national:update\", \"activity:published:update:contextual\",
                  \"activity:national:delete\", \"activity:feedback-settings:update\",
                  \"feedback:request:create:own\", \"feedback:received:read:own\",
                  \"feedback:request:read:assigned\", \"feedback:request:respond:assigned\",
                  \"feedback:history:read:contextual\", \"feedback:dashboard:read:contextual\",
                  \"primary-establishment:read\", \"primary-establishment:create\",
                  \"primary-establishment:update\", \"primary-establishment:delete\",
                  \"secondary-establishment:read\", \"secondary-establishment:create\",
                  \"secondary-establishment:update\", \"secondary-establishment:delete\",
                  \"group:read\", \"group:import\", \"group:create\", \"group:update\", \"group:delete\",
                  \"rbac:read\", \"rbac:assign\", \"rbac:revoke\", \"rbac:manage\"
                };

                ngx.log(ngx.ERR, \"serverless pre function\");

                local bearer = core.request.header(ctx, \"Authorization\");
                local token = \"\";

                if bearer ~= nil then
                  local _, _, payload = string.find(bearer, \"Bearer%s+(.+)\");
                  token = payload;
                end

                ngx.log(ngx.ERR, \"serverless pre function token prefix \", string.sub(token or \"\", 1, 20));

                local user_id = token_to_uuid[token];
                local now = ngx.time();
                local user_context = nil;

                if token == nil or token == \"\" then
                  return 401, {
                    message = \"Unauthorized: missing bearer token\",
                    status = 401,
                    code = \"UNAUTHORIZED\"
                  };
                end

                if user_id ~= nil then
                  user_context = {
                    sub = user_id,
                    iat = now,
                    exp = now + 300,
                    authorities = mock_authorities
                  };
                else
                  local httpc = http.new();

                  ngx.log(ngx.INFO, \"call security service for non-mock token\");

                  local res, err = httpc:request_uri(
                    \"http://avenirs-portfolio-security:12000/oidc/introspect\",
                    {
                      method = \"POST\",
                      headers = {
                        [\"x-authorization\"] = token,
                        [\"Content-Type\"] = \"application/json\"
                      }
                    }
                  );

                  if not res then
                    return 503, {
                      message = \"Security service unavailable\",
                      status = 503,
                      code = \"SECURITY_UNAVAILABLE\",
                      details = {
                        reason = err
                      }
                    };
                  end

                  if res.status ~= 200 then
                    ngx.log(ngx.ERR, \"security introspection failed with status \", res.status, \" body \", res.body or \"\");
                    return 401, {
                      message = \"Unauthorized: token introspection failed\",
                      status = 401,
                      code = \"UNAUTHORIZED\"
                    };
                  end

                  local ok, introspection = pcall(cjson.decode, res.body);

                  if not ok or introspection == nil then
                    return 500, {
                      message = \"Invalid security introspection response\",
                      status = 500,
                      code = \"INVALID_SECURITY_RESPONSE\"
                    };
                  end

                  if introspection.active ~= true then
                    return 401, {
                      message = \"Unauthorized: inactive token\",
                      status = 401,
                      code = \"UNAUTHORIZED\"
                    };
                  end

                  user_context = {
                    sub = introspection.userId or \"oidc-authenticated-user\",
                    iat = now,
                    exp = now + 300,
                    authorities = mock_authorities
                  };
                end

            local payload = cjson.encode(user_context);
            local hmac_key = \"$AVENIRS_PORTFOLIO_HMAC_SECRET\";
            local h = hmac:new(hmac_key, hmac.ALGOS.SHA256);
            h:update(payload);

            local signature_bin = h:final(nil, false);
            local signature_base64 = ngx.encode_base64(signature_bin);

            core.request.set_header(ctx, \"X-Signed-Context\", payload);
            core.request.set_header(ctx, \"X-Context-Signature\", signature_base64);
            ngx.req.clear_header(\"Authorization\");
            core.request.set_header(ctx, \"avenirsEndPoint\", ctx.var.uri);
                
                
            end"
      ]
    }
  }
}
EOF
)

curl -H "X-API-KEY: $SEC_APISIX_ADMIN_KEY" -i "$END_POINT" -X PUT -d "$JSON_CONTENT"


echo -ne "\n\n"