
import WebSocket from 'ws';
import { Client } from '@stomp/stompjs';


 

  Object.assign(global, { WebSocket });
  
  const client = new Client({
    brokerURL: 'http://localhost:10000/messages',
    onConnect: () => {
      console.log("Stomp client connected");
      client.subscribe('/notification/rt', message =>
        console.log(`Received: ${message.body}`)
      );
      client.publish({ destination: '/messages', body:JSON.stringify({user : "gribonvald", text: "barxxxx"} )});
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

