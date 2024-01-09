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

app.get('/hello', (req, res) => {
  console.log('HELLO INTERNAL')
  res.send('Hello World!')
});


app.get('/health', (req, res) => {
  console.log('HEALTH INTERNAL')
  console.log('Headers', req.headers);
  res.setHeader('Content-Type', 'application/json');
  res.end(JSON.stringify({ 'state': 'Green state' }));

});


app.get('/get_traces', (req, res) => { //https://github.com/login/oauth/authorize

  console.log('get_traces');
  res.end(JSON.stringify({ 'code': 'bar' }))

});
app.get('/get_traces/user', (req, res) => { //https://github.com/login/oauth/authorize

  console.log('get_traces/user', req);
  res.end(JSON.stringify({ 'code': 'bar' }))

});


app.post('/post_traces', (req, res) => { // https://github.com/login/oauth/authorize

  console.log('post_traces');
});

// https://casdev.univ-tln.fr/cas/oidc/oidcAuthorize?client_id=APIMClientId&redirect_uri=https://dev-backend.univ-tln.fr/cas-auth-callback&response_type=code&scope=openid profile
// https://localhost/cas/oidc/oidcAuthorize?client_id=APIMClientId&redirect_uri=https://dev-backend.univ-tln.fr/cas-auth-callback&response_type=code&scope=openid profile
app.get('/cas-auth-callback', (req, res) => {
  const sessionCode = req?.query?.code;
  //console.log('cas-auth-callback req', req);
  // res.end('OK');
  //GraviteeClientId
  //ErT322hVLHzIi9Z5tbu58yzUvzVqlsh3T0tmKRV41bu004wqY664TM=
  
  const uri = 'https://localhost/cas/oidc/oidcAuthorize';
  console.log('URI', uri);
  console.log('ICI1');
  
  const url=`${uri}?client_id=APIMClientId&client_secret=ErT322hVLHzIi9Z5tbu58yzUvzVqlsh3T0tmKRV41bu004wqY664TM=&redirect_uri=http://localhost/node-api/cas-auth-callback/access&code=${sessionCode}&scope=openid profile email&response_type=token&response_mode=form_post`
  console.log('url', url);

if (false) {
  console.log('ICI2');
  needle('get', url,     {
    'Content-Type':'application/json'
    }).then((response: any) => {
      console.log('OK', response.url)
      res.end(JSON.stringify(response.query));


      // }).catch((err: any)=> {
      //   console.log('ERROR', err)
      // })




    
    }) ;
}else {
  res.redirect(url);
// res.end('OK2');
}
});

app.get('/cas-auth-callback/access', (req, res) => {
  
  console.log('GET cas-auth-callback/access req.query', req?.query);
  res.end('OK3');
});


app.post('/cas-auth-callback/access', (req, res) => {
  
  console.log('POST cas-auth-callback/access req.body', req.body);
  res.end('OK3');
});


// https://github.com/login/oauth/authorize?client_id=ba924be86c03d6cc5312&redirect_uri=http://dev-backend.univ-tln.fr:3000/github-auth-callback&scope=user&response_type=code&state=39b99f33129777631c6efd6555650c6810150ec0
app.get('/github-auth-callback', (req, res) => {
  const sessionCode = req?.query?.code;
  console.log('github-auth-callback sessionCode', sessionCode);


  const uri = 'https://github.com/login/oauth/access_token';
  console.log('URI', uri);

  // res.end(JSON.stringify({'code':sessionCode}));

  needle('post', uri, {
    client_id: 'ba924be86c03d6cc5312',
    client_secret: '3e7fafb8bbf50f1775444a595bc77d45eed9c795',
    code: sessionCode,

  },
    {
      json: true
    }).then((response: any) => {
      console.log('OK', response.body)
      res.end(JSON.stringify(response.body));


      // }).catch((err: any)=> {
      //   console.log('ERROR', err)
      // })




      // .then((ghRes: any) => {
      //  // console.log('ghRes', ghRes);
      //   return ghRes;
      // })
      // .then((ghRes: any) => res.end(JSON.stringify({'ghRes':'ghRes'})))
      // ;
      /*
    'https://github.com/login/oauth/access_token',
                              {:client_id => CLIENT_ID,
                               :client_secret => CLIENT_SECRET,
                               :code => session_code
      */
    });
});


const HOST = '0.0.0.0';
const PORT = 3000;


app.listen(PORT, HOST, async () => {
  console.log('Listening on ' + HOST + ' Port:' + PORT);
  
 
});