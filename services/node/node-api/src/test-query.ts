import * as needle from 'needle';


const ba= { 'Authorization': 'Basic ' + Buffer.from('APIMClientId:ErT322hVLHzIi9Z5tbu58yzUvzVqlsh3T0tmKRV41bu004wqY664TM=' ).toString('base64')};

console.log('ba', ba)
'application/x-www-form-urlencoded'
const data = {
    token: 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCIsImtpZCI6Ijg4ZWNkM2ZiLWI2MjAtNGQ5MC05MDRlLTY2Yzc3ZTU1OTcwZCIsIm9yZy5hcGVyZW8uY2FzLnNlcnZpY2VzLlJlZ2lzdGVyZWRTZXJ2aWNlIjoiNDAwMCJ9.eyJzdWIiOiJkZW1hbiIsIm1haWwiOiJkZW1hbkB1bml2LmZyIiwib2F1dGhDbGllbnRJZCI6IkFQSU1DbGllbnRJZCIsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0L2NhcyIsImNsaWVudF9pZCI6IkFQSU1DbGllbnRJZCIsInVpZCI6ImRlbWFuIiwiZ3JhbnRfdHlwZSI6Im5vbmUiLCJzY29wZSI6Im9wZW5pZCBwcm9maWxlIGVtYWlsIiwic2VydmVySXBBZGRyZXNzIjoiMTcyLjIwLjAuMTAiLCJsb25nVGVybUF1dGhlbnRpY2F0aW9uUmVxdWVzdFRva2VuVXNlZCI6ZmFsc2UsInN0YXRlIjoiIiwic24iOiJERU1BTiIsImV4cCI6MTcwNTY5NzYzNCwiaWF0IjoxNzA1NjY4ODM0LCJqdGkiOiJBVC03LVJVTUpWTExMN1Q2TFRZb0hVM1c3WU5CNlBtclh1MDdMIiwiY2xpZW50SXBBZGRyZXNzIjoiMTcyLjIwLjAuMSIsImlzRnJvbU5ld0xvZ2luIjpmYWxzZSwiYXV0aGVudGljYXRpb25EYXRlIjoiMjAyNC0wMS0xOVQxMjozMzoyMy45NDU5OTU0NDVaIiwic3VjY2Vzc2Z1bEF1dGhlbnRpY2F0aW9uSGFuZGxlcnMiOiJMZGFwQXV0aGVudGljYXRpb25IYW5kbGVyIiwiZ2l2ZW5OYW1lIjoiYXJuYXVkIiwidXNlckFnZW50IjoiTW96aWxsYS81LjAgKFgxMTsgTGludXggeDg2XzY0OyBydjoxMjIuMCkgR2Vja28vMjAxMDAxMDEgRmlyZWZveC8xMjIuMCIsImNuIjoiREVNQU4gQXJuYXVkIiwibm9uY2UiOiIiLCJjcmVkZW50aWFsVHlwZSI6IlVzZXJuYW1lUGFzc3dvcmRDcmVkZW50aWFsIiwic2FtbEF1dGhlbnRpY2F0aW9uU3RhdGVtZW50QXV0aE1ldGhvZCI6InVybjpvYXNpczpuYW1lczp0YzpTQU1MOjEuMDphbTpwYXNzd29yZCIsImF1ZCI6IkFQSU1DbGllbnRJZCIsImF1dGhlbnRpY2F0aW9uTWV0aG9kIjoiTGRhcEF1dGhlbnRpY2F0aW9uSGFuZGxlciJ9.eG9ulZ_E0aGMt8dTKCHZF3R-7onVLQnQ789UMGQFUwDJ4udAmWkHIk0cE2It9gdE1LI_pNkLEiLrYhTGRnvvvA',
}

const options= {
   // multipart: true,
    headers: { 
        ...ba
     }
}
async function foo() {
    needle.post('http://localhost/cas/oidc/oidcProfile',data, options, (err, resp)=> {   
    // needle.post('http://localhost/cas/oidc/introspect',data, options, (err, resp)=> {   

    console.log('ICI', resp?.body);
    resp.on('done', (err)=> {
        console.log('et là')
    })
})
}
// needle.post('http://localhost/cas/oidc/introspect',data, options, (err, resp)=> {
//     console.log('ICI');
//     resp.on('done', (err)=> {
//         console.log('et là')
//     })
foo();
