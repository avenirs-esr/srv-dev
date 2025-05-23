require("module-alias/register");

console.log("-----------------------");
process.on("uncaughtException", (error) => {
  console.log("Catched uncaughtException: ", error);
  process.exit(1);
});
const {
  cas_client_id,
  cas_client_secret,
} = require("../settings/node-api-settings.json");
console.log("cas_client_id", cas_client_id);
console.log("cas_client_secret", cas_client_secret);

import { json, urlencoded } from "body-parser";
import express from "express";
//import { disableProxy } from './no-proxy';
import audit from "express-requests-logger";
import * as needle from "needle";

const cors = require("cors");
const bodyQueryBoolean = require("express-query-boolean");
const app = express();
app.use(
  cors({
    origin: "*",
    optionsSuccessStatus: 200,
  })
);
app.use(json());
app.use(bodyQueryBoolean());
app.use(
  urlencoded({
    extended: true,
  })
);

app.use(audit());

process.env["NODE_TLS_REJECT_UNAUTHORIZED"] = "0";

/**
 * Health method to check quickly if the backend is responding.
 */
app.get("/health", (req: any, res: any) => {
  //  console.log('Headers', req.headers);

  res.setHeader("Content-Type", "application/json");
  res.end(JSON.stringify({ state: "Green state" }));
});

/**
 * Cas oidc authentication callback.
 * Call the cas oidcAuthorize end point to generate a jwt (access token) from a session code.
 * After authorization cas will redirect to the uri given in parameter (must be declared in service definition of CAS).
 */
app.get("/cas-auth-callback", (req: any, res: any) => {
  const sessionCode = req?.query?.code;
  const host = req.headers?.["x-forwarded-host"] || "localhost";
  console.log("cas-auth-callback host", host);
  console.log("cas-auth-callback sessionCode", sessionCode);

  const uri = `https://${host}/cas/oidc/oidcAuthorize`;
  console.log("URI", uri);
  const url = `${uri}?client_id=${cas_client_id}&client_secret=${cas_client_secret}&redirect_uri=http://${host}/node-api/cas-auth-callback/access&code=${sessionCode}&scope=openid profile email&response_type=token`;
  console.log("url", url);
  res.redirect(url);
});

/**
 * Redirection used after CAS authorization.
 */
app.post("/debug", (req: any, res: any) => {
  console.log("/debug req.headers", req.headers);
  console.log("/debug req.body", req.body);
  console.log("/debug req.query", req.query);

  res.json(req.headers);
});
app.get("/debug", (req: any, res: any) => {
  console.log("/debug req.headers", req.headers);
  console.log("/debug req.body", req.body);
  console.log("/debug req.query", req.query);

  res.json(req.headers);
});

/**
 * Redirection used after CAS authorization.
 */
app.get("/cas-auth-callback/access", (req: any, res: any) => {
  const host = req.headers?.["x-forwarded-host"] || "localhost";
  console.log("cas-auth-callback/access host", host);
  res.redirect(`http://${host}/examples/authentication-webcomp-demo/`);
});

/**
 * Validates a jwt. If the jwt is valid the claims will be returned.
 * Uses the introspection end point of CAS.
 */
app.post("/cas-auth-validate", (req: any, res: any) => {
  const host = req.headers?.["x-forwarded-host"] || "localhost";
  const token = req.get("x-authorization");
  console.log("cas-auth-validate host", host);
  console.log("cas-auth-validate token", token);

  const introspectEndPoint = `http://avenirs-apache/cas/oidc/introspect`;
  console.log("cas-auth-validate introspectEndPoint", introspectEndPoint);

  const options = {
    headers: {
      Authorization:
        "Basic " +
        Buffer.from(`${cas_client_id}:${cas_client_secret}`).toString("base64"),
    },
  };

  console.log("cas-auth-validate options.headers", options.headers);

  needle.post(
    introspectEndPoint,
    { token },
    options,
    (err: any, resp: needle.NeedleResponse) => {
      res.setHeader("Content-Type", "application/json");
      if (err) {
        res
          .status(500)
          .end(
            JSON.stringify({ message: "Unexpected error", error: err }) + "\n"
          );
      } else {
        const introspectResponse = resp?.body;
        const active = introspectResponse?.active;
        console.log("cas-auth-validate introspectResponse", introspectResponse);
        if (!active) {
          console.log("cas-auth-validate not active status will be 404");
          res.status(404).end(JSON.stringify(introspectResponse) + "\n");
        } else {
          if (introspectResponse.token) {
            console.log("cas-auth-validate token found in introspectResponse");
            needle.post(
              "https://avenirs-apache/cas/oidc/profile",
              { token: introspectResponse.token },
              options,
              (err: any, resp: any) => {
                console.log("cas-auth-validate in profile");
                if (err) {
                  console.log("cas-auth-validate in profile err", err);
                  res.status(500).end(JSON.stringify(err) + "\n");
                } else {
                  console.log(
                    "cas-auth-validate in profile resp.body",
                    resp.body
                  );
                  res.status(200).end(
                    JSON.stringify({
                      ...introspectResponse,
                      profile: resp?.body,
                    }) + "\n"
                  );
                }
              }
            );
          } else {
            res
              .status(500)
              .end(
                "The token is missing in the introspect response: " +
                  JSON.stringify(err) +
                  "\n"
              );
          }
        }
      }
    }
  );
});

async function _introspect(token: string) {
  const introspectEndPoint = `http://avenirs-apache/cas/oidc/introspect`;
  console.log("_introspect introspectEndPoint", introspectEndPoint);

  const options = {
    headers: {
      Authorization:
        "Basic " +
        Buffer.from(`${cas_client_id}:${cas_client_secret}`).toString("base64"),
    },
  };

  console.log("_introspect", options.headers);

  return new Promise((resolve, reject) => {
    needle.post(
      introspectEndPoint,
      { token },
      options,
      (err: any, resp: needle.NeedleResponse) => {
        console.log("_introspect err", err);
        console.log("_introspect resp?.body", resp?.body);
        return err ? reject(err) : resolve(resp?.body);
      }
    );
  });
}

/** ---- Access control experimentation ---- **/
app.get("/display", async (req: any, res: any) => {
  console.log("=>", req.query?.resource);
  const host = req.headers?.["x-forwarded-host"] || "localhost";
  const token = req.get("x-authorization") || "";
  const resource = req.query?.resource;
  res.status(200).end(
    JSON.stringify({
      uri: "/display",
      host,
      resource,
      token,
    })
  );
});

app.post("/edit", async (req: any, res: any) => {
  console.log("display edit =>", req.body);
  const host = req.headers?.["x-forwarded-host"] || "localhost";
  const token = req.get("x-authorization") || req.get("Authorization") || "";
  const resource = req.query?.resource;
  res.status(200).end(JSON.stringify({ uri: "/edit", host, resource, token }));
});

/** ---- Access control integration experimentation ---- **/
app.get("/ac-in-apim", async (req: any, res: any) => {
  const host = req.headers?.["x-forwarded-host"] || "localhost";
  const token = req.get("x-authorization") || req.get("Authorization") || "";
  const action = req.query?.action;
  res.status(200).end(JSON.stringify({ uri: "/ac-alone", host, action }));
});

app.get("/ac-inlined", async (req: any, res: any) => {
  //const acEndPoint = 'http://localhost:12000/access-control/authorize';
  const acEndPoint = 'http://avenirs-apache/avenirs-portfolio-security/access-control/authorize';
  const token = req.get("x-authorization") || req.get("Authorization") || "";
  const uri = "/ac_integration";
  const method = "GET";
  const resourceId = req.query?.resourceId;

  console.log("ac-inlined acEndPoint", acEndPoint);
  console.log("ac-inlined uri", uri);
  console.log("ac-inlined method", method);
  console.log("ac-inlined resourceId", resourceId);
  
  const options = {
    headers: {
      "x-authorization": token,
    },
  };

  console.log("ac-inlined", options.headers);

  
  needle.get(
    `${acEndPoint}?uri=${uri}&method=${method}&resourceId=${resourceId}`,
  
    options,
    (err: any, resp: needle.NeedleResponse) => {
      console.log("ac-inlined err", err);
      console.log("ac-inlined resp?.statusCode", resp?.statusCode);
      console.log("ac-inlined resp?.body", resp?.body.toString());
      if (err) {
        res.status(500).json({ error: err });
      } else if (resp.statusCode === 403) {
        res.status(403).json({ error: "Forbidden" });
      } else if (resp.statusCode === 200) {
        res
          .status(200)
          .end(JSON.stringify({ uri: "/ac-inlined", method }));
      } else {
        res.status(500).json({ error: "Unexpected Internal Server Error" });
      }
      
    }
  );
  
});

app.post("/access-token", async (req: any, res: any) => {
  //const loginEndPoint = 'http://localhost:12000/oidc/login';
  const loginEndPoint = 'http://avenirs-apache/avenirs-portfolio-security/oidc/login';
  const login = req.query?.login || 'deman';
  const password = req.query?.password || 'Azerty123';
  const params = {
    login,
    password,
  };
  console.log('Using endPoint:', loginEndPoint);
  console.log('Params:', params);
  needle.post(
    loginEndPoint,
    params,
    { json: true },
    (err: any, resp: needle.NeedleResponse) => {
      if (err) {
        res.status(500).json({ error: err });
      } else if (resp.statusCode === 403) {
        res.status(403).json({ error: "Forbidden" });
      } else if (resp.statusCode === 200) {
        res
          .status(200)
          .end(resp?.body.toString());
      } else {
        res.status(500).json({ error: "Unexpected Internal Server Error" });
      }
    }
  );
});

/** ---- dynamic upstream experimentation ---- **/

/**
 * Select upstream
 */
app.get("/select-upstream", async (req: any, res: any) => {
  console.log("Dynamic Upstream experimentation: select-upstream");
  console.log(
    "Dynamic Upstream experimentation: select-upstream headers",
    JSON.stringify(req.header)
  );
  console.log(
    "Dynamic Upstream experimentation:select body : " + JSON.stringify(req.body)
  );
  console.log(
    "Dynamic Upstream experimentation:select query : " +
      JSON.stringify(req.query)
  );
  res.setHeader("Content-Type", "application/json");
  const introspect: any = await _introspect(req.header("x-authorization"));
  console.log("Dynamic Upstream experimentation: introspect", introspect);
  console.log(
    "Dynamic Upstream experimentation: introspect?.uniqueSecurityName: ",
    introspect?.uniqueSecurityName
  );
  const payload1 = {
    upstream: "univ1",
    endPoint: "/node-api/endPoint1",
  };
  const payload2 = {
    upstream: "univ2",
    endPoint: "endPoint2",
  };

  const payload =
    introspect?.uniqueSecurityName === "deman" ? payload1 : payload2;
  //const payload = payload1;
  console.log(
    "Dynamic Upstream experimentation: select-upstream payload",
    JSON.stringify(payload)
  );
  res.status(200).end(JSON.stringify(payload) + "\n");
});

/**
 * endPoint 1
 */
app.get("/endPoint1", (req: any, res: any) => {
  console.log("Dynamic Upstream experimentation endPoint1");
  console.log(
    "Dynamic Upstream experimentation: endPoint1  headers : " +
      JSON.stringify(req.headers)
  );
  res.setHeader("Content-Type", "application/json");
  const payload = { upstream: "upstream #1" };
  res.status(200).end(JSON.stringify(payload) + "\n");
});

/**
 * endPoint 2
 */
app.get("/endPoint2", (req: any, res: any) => {
  console.log("Dynamic Upstream experimentation /endPoint2");
  console.log(
    "Dynamic Upstream experimentation: endPoint2  headers : " +
      JSON.stringify(req.headers)
  );
  res.setHeader("Content-Type", "application/json");
  const payload = { upstream: "upstream #2" };
  res.status(200).end(JSON.stringify(payload) + "\n");
});

/**
 * Upstream 2
 */
app.get("/ds", (req: any, res: any) => {
  console.log("Dynamic Upstream experimentation /ds2");
  console.log(
    "Dynamic Upstream experimentation: ds  headers : " +
      JSON.stringify(req.headers)
  );
  res.setHeader("Content-Type", "application/json");
  const payload = { upstream: "ds" };
  res.status(200).end(JSON.stringify(payload) + "\n");
});

/** ---- Authentication mock experimentation ---- **/
app.get("/auth-mock-test", (req: any, res: any) => {
  console.log("Authentication mock experimentation");
  
  res.setHeader("Content-Type", "application/json");
  const payload = { state: "OK (auth-mock-test)" };
  res.status(200).end(JSON.stringify(payload) + "\n");
});




/** ---- end of experimentations ---- **/


const HOST = "0.0.0.0";
const PORT = 3000;

app.listen(PORT, HOST, async () => {
  console.log("Listening on " + HOST + " Port:" + PORT);
});
import "./experiment/test-ws-server";
