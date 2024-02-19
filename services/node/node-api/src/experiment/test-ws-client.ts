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
import WebSocket from 'ws';

const ws = new WebSocket('ws://localhost:9080/kafka');
function textToBin(text: string) {
    var length = text.length,
        output = [];
    for (var i = 0;i < length; i++) {
      var bin = text[i].charCodeAt(0).toString(2);
      output.push(Array(8-bin.length+1).join("0") + bin);
    } 
    return output;
  }
ws.on('error', console.error);

ws.on('open', function open() {
  const array = new Float32Array(5);

  for (var i = 0; i < array.length; ++i) {
    array[i] = i / 2;
  }
  const msg: any = textToBin(JSON.stringify({
    "req" : "cmd_ping"
}));
const x = JSON.stringify({req :{
    sequence : 7,
   cmd_kafka_fetch : {
        topic: "avenirs-api",
        partition : 0,
        offset : 0,
    },
}});
const m : any = {
    "topic" : "avenirs-notification",
    "partition" : "0",
    "timestamp" : "-1"
}

  console.log('send')
  ws.send(x, {binary: true}, (err: any) => console.log('send callback err', err));
});
