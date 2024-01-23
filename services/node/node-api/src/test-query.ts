import * as needle from 'needle';


const data = {
    token: 'eyJhbGciOiJSUzUxMiIsInR5cCI6IkpXVCIsImtpZCI6ImNhcy1kZHhpZnFNWCIsIm9yZy5hcGVyZW8uY2FzLnNlcnZpY2VzLlJlZ2lzdGVyZWRTZXJ2aWNlIjoiNDAwMCJ9.eyJzdWIiOiJkZW1hbiIsIm9hdXRoQ2xpZW50SWQiOiJBUElNQ2xpZW50SWQiLCJyb2xlcyI6W10sImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0L2NhcyIsImNsaWVudF9pZCI6IkFQSU1DbGllbnRJZCIsImdyYW50X3R5cGUiOiJub25lIiwicGVybWlzc2lvbnMiOltdLCJzY29wZSI6WyJvcGVuaWQiLCJwcm9maWxlIiwiZW1haWwiXSwic2VydmVySXBBZGRyZXNzIjoiMTcyLjIwLjAuNiIsImxvbmdUZXJtQXV0aGVudGljYXRpb25SZXF1ZXN0VG9rZW5Vc2VkIjpmYWxzZSwic3RhdGUiOiIiLCJleHAiOjE3MDYwNDQ1MTIsImlhdCI6MTcwNjAxNTcxMiwianRpIjoiQVQtOC1VRU45NDFLWDhpbkhuaTZvTUJlUHhDdEp6endVWVdoUiIsImVtYWlsIjoiZGVtYW5AdW5pdi5mciIsImNsaWVudElwQWRkcmVzcyI6IjE3Mi4yMC4wLjEiLCJpc0Zyb21OZXdMb2dpbiI6dHJ1ZSwiYXV0aGVudGljYXRpb25EYXRlIjoiMjAyNC0wMS0yM1QxMzoxNToxMi4xMjIzNTdaIiwic3VjY2Vzc2Z1bEF1dGhlbnRpY2F0aW9uSGFuZGxlcnMiOiJMZGFwQXV0aGVudGljYXRpb25IYW5kbGVyIiwidXNlckFnZW50IjoiTW96aWxsYS81LjAgKFgxMTsgTGludXggeDg2XzY0OyBydjoxMjIuMCkgR2Vja28vMjAxMDAxMDEgRmlyZWZveC8xMjIuMCIsImdpdmVuX25hbWUiOiJERU1BTiBBcm5hdWQiLCJub25jZSI6IiIsImNyZWRlbnRpYWxUeXBlIjoiVXNlcm5hbWVQYXNzd29yZENyZWRlbnRpYWwiLCJzYW1sQXV0aGVudGljYXRpb25TdGF0ZW1lbnRBdXRoTWV0aG9kIjoidXJuOm9hc2lzOm5hbWVzOnRjOlNBTUw6MS4wOmFtOnBhc3N3b3JkIiwiYXVkIjoiQVBJTUNsaWVudElkIiwiYXV0aGVudGljYXRpb25NZXRob2QiOiJMZGFwQXV0aGVudGljYXRpb25IYW5kbGVyIiwic2NvcGVzIjpbIm9wZW5pZCIsInByb2ZpbGUiLCJlbWFpbCJdLCJmYW1pbHlfbmFtZSI6IkRFTUFOIn0.bXh0uLuz9iMa2sNWg7tFmvhMxRf1tTcdcttkNXy90jAZFrFA6MVapR2WndG3PWuU55yEmkhJUyZWxKVs5G7vfPFYV9TYJ2QFdKFoxC6MJSv8U9ZE05hPc5Tq93b5ZREoLnG1CSteEEss9pXxOiu67G5OapqD06f_uKqKa6Yf9ETea4J6nuwm2N-oovEwfsdLZuUseZD5bNMsPXO_0KpdstqwZmg49ZkqKvxQ4L-6P1lPgUau2xCOP-eLNvUo_C89sMJOZTUTNWAUk_7dQSBtUb77AuCATCm7WtrK2zFr2AaPso57dPxKvzVfEseekK6bmRAvkIX9xat-2nsyF7Cazw',
    
}

const options= {
   // multipart: true,
    headers: { 
        'Authorization': 'Basic ' + Buffer.from('APIMClientId:ErT322hVLHzIi9Z5tbu58yzUvzVqlsh3T0tmKRV41bu004wqY664TM=' ).toString('base64')
     }
}
async function fetchProfile() {
     //needle.post('http://localhost/cas/oidc/profile',data, options, (err, resp)=> {   
      needle.post('http://localhost/cas/oidc/introspect',data, options, (err, resp)=> {   

    console.log('resp?.body', resp?.body);
    
})
}

fetchProfile();
