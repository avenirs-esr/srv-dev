require('module-alias/register');
console.log('-----------------------');
process.on('uncaughtException', (error) => {
  console.log('Catched uncaughtException: ', error);
  process.exit(1);

})

import { json, urlencoded } from 'body-parser';
import express from 'express';
//import { disableProxy } from './no-proxy';
import audit from 'express-requests-logger';
import * as needle from 'needle';

const cors = require('cors');
const bodyQueryBoolean = require('express-query-boolean');
const app = express();
app.use(cors({
  origin: '*',
  optionsSuccessStatus: 200
}));
app.use(json());
app.use(bodyQueryBoolean());
app.use(urlencoded({
  extended: true
}));

app.use(audit())


/**
 * Health method to check quickly if the banckend is responding.
 */
app.get('/health', (req, res) => {
  //  console.log('Headers', req.headers);

  res.setHeader('Content-Type', 'application/json');
  res.end(JSON.stringify({ 'state': 'Green state' }));
});


/**
 * Cas oidc authentication callback. 
 * Call the cas oidcAuthorize end point to generate a jwt (access token) from a session code.
 * After authorization cas will redirect to the uri given in parameter (must be declared in service definition of CAS).
 */
app.get('/cas-auth-callback', (req, res) => {
  const sessionCode = req?.query?.code;
  const host = req.headers?.['x-forwarded-host'] || 'localhost'
  console.log('cas-auth-callback host', host);
  console.log('cas-auth-callback sessionCode', sessionCode);

  const uri = `https://${host}/cas/oidc/oidcAuthorize`;
  console.log('URI', uri);
  const url = `${uri}?client_id=APIMClientId&client_secret=ErT322hVLHzIi9Z5tbu58yzUvzVqlsh3T0tmKRV41bu004wqY664TM=&redirect_uri=http://${host}/node-api/cas-auth-callback/access&code=${sessionCode}&scope=openid profile email&response_type=token`
  console.log('url', url);
  res.redirect(url);
});

/**
 * Redirection used after CAS authorization.
 */
app.get('/cas-auth-callback/access', (req, res) => {
  const host = req.headers?.['x-forwarded-host'] || 'localhost'
  console.log('cas-auth-callback/access host', host);
  res.redirect(`http://${host}/examples/authentication-webcomp-demo/`)
  
});


/**
 * Validates a jwt. If the jwt is valid the claims will be returned.
 * Uses the introspection end point of CAS.
 */
app.post('/cas-auth-validate', (req, res) => {
  const host = req.headers?.['x-forwarded-host'] || 'localhost'
  const token = req.get('x-authorization');
  console.log('cas-auth-validate host', host);
  console.log('cas-auth-validate token', token);

  const introspectEndPoint = `http://avenirs-apache/cas/oidc/introspect`;
  console.log('cas-auth-validate introspectEndPoint', introspectEndPoint);

  const options = {
    headers: {
      'Authorization': 'Basic ' + Buffer.from('APIMClientId:ErT322hVLHzIi9Z5tbu58yzUvzVqlsh3T0tmKRV41bu004wqY664TM=').toString('base64')
    }
  }


  needle.post(introspectEndPoint, { token }, options, (err: any, resp: needle.NeedleResponse) => {

    res.setHeader('Content-Type', 'application/json');
    if (err) {
      res.status(500).end(JSON.stringify({ message: 'Unexpected error', error: err }) + "\n");
    } else {
      const introspectResponse = resp?.body;
      const active = introspectResponse?.active;
      console.log('cas-auth-validate introspectResponse', introspectResponse);
      if (!active) {
        console.log('cas-auth-validate not active status will be 404');
        res.status(404).end(JSON.stringify(introspectResponse) + '\n');
      } else {
        if (introspectResponse.token) {
          console.log('cas-auth-validate token found in introspectResponse');
          needle.post('http://avenirs-apache/cas/oidc/profile', { token: introspectResponse.token }, options, (err, resp) => {
            console.log('cas-auth-validate in profile');
            if (err) {
              console.log('cas-auth-validate in profile err', err);
              res.status(500).end(JSON.stringify(err) + '\n');
            } else {
              console.log('cas-auth-validate in profile resp.body', resp.body);
              res.status(200).end(JSON.stringify({
                ...introspectResponse,
                profile: resp?.body
              }) + '\n');
            }
          });
        } else {
          res.status(500).end("The token is missing in the introspect response: " + JSON.stringify(err) + '\n');
        }
      }
    }
  });
});

const HOST = '0.0.0.0';
const PORT = 3000;


app.listen(PORT, HOST, async () => {
  console.log('Listening on ' + HOST + ' Port:' + PORT);


});