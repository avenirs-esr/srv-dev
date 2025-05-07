
import WebSocket from 'ws';
import { Client } from '@stomp/stompjs';

const TOKEN="eyJhbGciOiJSUzUxMiIsInR5cCI6IkpXVCIsImtpZCI6ImNhcy15dmlTWUphSCIsIm9yZy5hcGVyZW8uY2FzLnNlcnZpY2VzLlJlZ2lzdGVyZWRTZXJ2aWNlIjoiNDAwMCJ9.eyJzdWIiOiJkZW1hbiIsIm9hdXRoQ2xpZW50SWQiOiJBUElNQ2xpZW50SWQiLCJyb2xlcyI6W10sImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0L2NhcyIsImNsaWVudF9pZCI6IkFQSU1DbGllbnRJZCIsImdyYW50X3R5cGUiOiJub25lIiwicGVybWlzc2lvbnMiOltdLCJzY29wZSI6WyJvcGVuaWQiLCJwcm9maWxlIiwiZW1haWwiXSwic2VydmVySXBBZGRyZXNzIjoiMTkyLjE2OC42NC4xMiIsImxvbmdUZXJtQXV0aGVudGljYXRpb25SZXF1ZXN0VG9rZW5Vc2VkIjpmYWxzZSwic3RhdGUiOiIiLCJleHAiOjE3MDg5ODI3OTIsImlhdCI6MTcwODk1Mzk5MiwianRpIjoiQVQtMS1IUkRVMXZXeFJDUE1CLWkzdEJkQ2toZWQ4RXZodjdnMCIsImVtYWlsIjoiZGVtYW5AdW5pdi5mciIsImNsaWVudElwQWRkcmVzcyI6IjE5Mi4xNjguNjQuMSIsImlzRnJvbU5ld0xvZ2luIjp0cnVlLCJhdXRoZW50aWNhdGlvbkRhdGUiOiIyMDI0LTAyLTI2VDEzOjI2OjMxLjk1MTc0NVoiLCJzdWNjZXNzZnVsQXV0aGVudGljYXRpb25IYW5kbGVycyI6IkxkYXBBdXRoZW50aWNhdGlvbkhhbmRsZXIiLCJ1c2VyQWdlbnQiOiJNb3ppbGxhLzUuMCAoWDExOyBMaW51eCB4ODZfNjQ7IHJ2OjEyMi4wKSBHZWNrby8yMDEwMDEwMSBGaXJlZm94LzEyMi4wIiwiZ2l2ZW5fbmFtZSI6IkRFTUFOIEFybmF1ZCIsIm5vbmNlIjoiIiwiY3JlZGVudGlhbFR5cGUiOiJVc2VybmFtZVBhc3N3b3JkQ3JlZGVudGlhbCIsInNhbWxBdXRoZW50aWNhdGlvblN0YXRlbWVudEF1dGhNZXRob2QiOiJ1cm46b2FzaXM6bmFtZXM6dGM6U0FNTDoxLjA6YW06cGFzc3dvcmQiLCJhdWQiOiJBUElNQ2xpZW50SWQiLCJhdXRoZW50aWNhdGlvbk1ldGhvZCI6IkxkYXBBdXRoZW50aWNhdGlvbkhhbmRsZXIiLCJzY29wZXMiOlsib3BlbmlkIiwicHJvZmlsZSIsImVtYWlsIl0sImZhbWlseV9uYW1lIjoiREVNQU4ifQ.gSjy8t3cbHypwnyueEIhdkKGZs0vwDotcKlKqii3EIDbgWM7GhD1LXktUGZE4_WmUsGT9K0x2lSud3CBFzQ5O14C0YWbppChBjKeAjd2GCdPXTn5iB2nyTQVf3nkesI_dAtRuuyflUwDM18SW2XRyOsP73NKEoXmkSvfqbyjRBLAU7Mpsp7SycITcurtGION1LG6Dh7qbjcPZiue1ndpLF60EtkOeZ8Fs2GE4DcFvr--2EXnZZS9eg-3B1wemsII3CDOPw8cX2c5JgIET0XdHqo8P0soYNOolR41FpqSRP-TC9b3g8ED5TULN0ga8GAFlGTpnFf6iaxMJJzED4MyiQ"

 

  Object.assign(global, { WebSocket });
  
  const client = new Client({
    // brokerURL: 'http://localhost:9080/rt-notification', // OK via apisix gw directly
    // brokerURL: 'ws://localhost/apim/rt-notification', // OK Via Apache frontal
    connectHeaders:{
      "Authorization": `Bearer ${TOKEN}`
    },
    brokerURL: 'ws://localhost:10000/rt-notification', // Direct avenirs-api
    onConnect: () => {
      console.log("Stomp client connected");
      client.subscribe('/realtime', message =>
        console.log(`Received: ${message.body}`)
      );
      client.publish({ 
        destination: '/rt-notification', 
        headers: {"Authorization": `Bearer ${TOKEN}`},
        body:JSON.stringify({user : "gribonvald"} )});
    },

    onStompError:(frame) =>{
      // Will be invoked in case of error encountered at Broker
      // Bad login/passcode typically will cause an error
      // Complaint brokers will set `message` header with a brief message. Body may contain details.
      // Compliant brokers will terminate the connection after any error
      console.log('Broker reported error: ' + frame.headers['message']);
      console.log('Additional details: ' + frame.body);
    }
  });
  
  client.activate();

