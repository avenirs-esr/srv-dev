// const socketClient = require('socket.io-client');
// const socket = socketClient.connect('http://localhost:9080/kafka');

// socket.on('connect', function () {
//   console.log('connected to server');

//   //Subscribe to the "example-channel"
//   socket.emit('subscribe', 'avenirs-notification');

//   //Listen for messages from the "example-channel"
//   socket.on('message', function (message: any) {
//     console.log('received message:', message);
//   });
// });
import * as protobuf from 'protobufjs'

import WebSocket from 'ws';
const PROTO_FILE = __dirname + '/../../../assets/pubsub.proto';
console.log("Loading protobuf file: " + PROTO_FILE);

protobuf.load(PROTO_FILE, function (err, root) {

  if (err) {
    console.error("Error while loading protobuf:", err);
    process.exit(1);
  }
  if (root) {
    console.log("Protobuf loaded");


    const ws = new WebSocket('ws://localhost:9080/kafka');

    ws.on('error', console.error);

    ws.on('open', function open() {
      console.log("Websocket opened")
      const payload: any = {
        sequence: 2,
        cmdKafkaFetch: {
          topic: "avenirs-notification",
          partition: 0,
          offset: 0
        }
      }

      const PubSubReq = root.lookupType("PubSubReq");
      const PubSubResp = root.lookupType("PubSubResp");
      if (PubSubReq && PubSubResp){
        console.log('PubSubReq and PubSubResp types loaded');

        ws.on('message', (data: Buffer) => {
          console.log('Recieved message', data);
          const decoded = PubSubResp.decode(data)
          console.log('Recieved decoded data', decoded);
          ((decoded as any)?.kafkaFetchResp?.messages).forEach((message :any) => {
            console.log('      Recieved message?.value', message?.value?.toString());
            
          });
        });
        
        const encoded = PubSubReq.encode(payload).finish();
        console.log('Encoded Buffer', encoded.toString());
        ws.send(encoded, {binary: true}, (err: any) => console.log('send callback err', err));
      } else {
        console.error('Unable to load PubSubReq Type');
        process.exit(1);
      }
    });
  } else {
    console.log('Error: enable to load root from protobuf definition: ', PROTO_FILE);
    process.exit(1);
  }
});


// ws.send(x, {binary: true}, (err: any) => console.log('send callback err', err));

