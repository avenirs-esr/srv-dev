
import WebSocket from 'ws';
import { Client } from '@stomp/stompjs';


 

  Object.assign(global, { WebSocket });
  
  const client = new Client({
    // brokerURL: 'http://localhost:9080/rt-notification', // OK via apisix gw directly
    brokerURL: 'ws://localhost/apisix-gw/rt-notification', // OK Via Apache frontal
    onConnect: () => {
      console.log("Stomp client connected");
      client.subscribe('/realtime', message =>
        console.log(`Received: ${message.body}`)
      );
      client.publish({ destination: '/rt-notification', body:JSON.stringify({user : "gribonvald"} )});
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

