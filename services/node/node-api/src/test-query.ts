import * as needle from 'needle';


const data = {
    token: 'eyJhbGciOiJSUzUxMiIsInR5cCI6IkpXVCIsImtpZCI6ImNhcy1VZUNtck5UTiIsIm9yZy5hcGVyZW8uY2FzLnNlcnZpY2VzLlJlZ2lzdGVyZWRTZXJ2aWNlIjoiNDAwMCJ9.eyJzdWIiOiJkZW1hbiIsIm9hdXRoQ2xpZW50SWQiOiJBUElNQ2xpZW50SWQiLCJyb2xlcyI6W10sImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0L2NhcyIsImNsaWVudF9pZCI6IkFQSU1DbGllbnRJZCIsImdyYW50X3R5cGUiOiJub25lIiwicGVybWlzc2lvbnMiOltdLCJzY29wZSI6WyJvcGVuaWQiLCJwcm9maWxlIiwiZW1haWwiXSwic2VydmVySXBBZGRyZXNzIjoiMTcyLjI2LjAuMiIsImxvbmdUZXJtQXV0aGVudGljYXRpb25SZXF1ZXN0VG9rZW5Vc2VkIjpmYWxzZSwic3RhdGUiOiIiLCJleHAiOjE3MDU5Njc5OTksImlhdCI6MTcwNTkzOTE5OSwianRpIjoiQVQtMi1NTC1BOFNoNVRqMnRsQzRpWXZtc1ZKVWhJaGFaZ2UtayIsImNsaWVudElwQWRkcmVzcyI6IjE3Mi4yNi4wLjEiLCJpc0Zyb21OZXdMb2dpbiI6dHJ1ZSwiYXV0aGVudGljYXRpb25EYXRlIjoiMjAyNC0wMS0yMlQxNTo1OTo1OS44OTYxOTFaIiwic3VjY2Vzc2Z1bEF1dGhlbnRpY2F0aW9uSGFuZGxlcnMiOiJMZGFwQXV0aGVudGljYXRpb25IYW5kbGVyIiwidXNlckFnZW50IjoiTW96aWxsYS81LjAgKFgxMTsgTGludXggeDg2XzY0OyBydjoxMjEuMCkgR2Vja28vMjAxMDAxMDEgRmlyZWZveC8xMjEuMCIsIm5vbmNlIjoiIiwiY3JlZGVudGlhbFR5cGUiOiJVc2VybmFtZVBhc3N3b3JkQ3JlZGVudGlhbCIsInNhbWxBdXRoZW50aWNhdGlvblN0YXRlbWVudEF1dGhNZXRob2QiOiJ1cm46b2FzaXM6bmFtZXM6dGM6U0FNTDoxLjA6YW06cGFzc3dvcmQiLCJhdWQiOiJBUElNQ2xpZW50SWQiLCJhdXRoZW50aWNhdGlvbk1ldGhvZCI6IkxkYXBBdXRoZW50aWNhdGlvbkhhbmRsZXIiLCJzY29wZXMiOlsib3BlbmlkIiwicHJvZmlsZSIsImVtYWlsIl19.BR-cyxgF_I61xovWtP3ltHkBL96SaST8L82PHVidt-55_cK6zxn8JO0Lg0bQeLPbjkw9DbwQg6dDATgnadHM1r51R17NnCcizzHKPwFB5oDZe2NHWwbQ6R5AB6FyG6fhHLm4q_-3GZXOLrCZ511byKx3rR84OANK7VQ3bwERHA1NW4kgvkIhQSkm06fTLS2_mQsnI31RA08_eQO9rG2sddMf16bBKyvPhadQE_W7qe1hmBeDLzC-DeOmdJNbopEDe4MM0rj14ZqcNQmlFfN6xfnldfplU7KhwaHW3AhVfeBM-yFEGuEvcoKpTCoTgEcRHsZVnRj7gQEiFcVKk0-gVw',
    
}

const options= {
   // multipart: true,
    headers: { 
        'Authorization': 'Basic ' + Buffer.from('APIMClientId:ErT322hVLHzIi9Z5tbu58yzUvzVqlsh3T0tmKRV41bu004wqY664TM=' ).toString('base64')
     }
}
async function foo() {
     needle.post('http://localhost/cas/oidc/profile',data, options, (err, resp)=> {   
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
