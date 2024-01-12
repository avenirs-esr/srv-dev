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



var needle = require('needle');

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



app.get('/health', (req, res) => {
  //  console.log('Headers', req.headers);
  
  res.setHeader('Content-Type', 'application/json');
  res.end(JSON.stringify({ 'state': 'Green state' }));
});


// https://localhost/cas/oidc/oidcAuthorize?client_id=APIMClientId&redirect_uri=https://localhost/node-api/cas-auth-callback&response_type=code&scope=openid profile
app.get('/cas-auth-callback', (req, res) => {
  const sessionCode = req?.query?.code;
  const host=req.headers?.['x-forwarded-host'] || 'localhost'
  console.log('cas-auth-callback host', host);
  console.log('cas-auth-callback sessionCode', sessionCode);
  
  const uri = `https://${host}/cas/oidc/oidcAuthorize`;
  console.log('URI', uri);
  
  const url=`${uri}?client_id=APIMClientId&client_secret=ErT322hVLHzIi9Z5tbu58yzUvzVqlsh3T0tmKRV41bu004wqY664TM=&redirect_uri=https://${host}/node-api/cas-auth-callback/access&code=${sessionCode}&scope=openid profile email&response_type=token`
  console.log('url', url);
  res.redirect(url);
});

app.get('/cas-auth-callback/access', (req, res) => {
  const host=req.headers?.['x-forwarded-host'] || 'localhost'
  console.log('cas-auth-callback/access host', host);
  res.redirect(`https://${host}/examples/apisix-oidc-callback.html`)
});

const HOST = '0.0.0.0';
const PORT = 3000;


app.listen(PORT, HOST, async () => {
  console.log('Listening on ' + HOST + ' Port:' + PORT);
  
 
});