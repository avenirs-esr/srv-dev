import WebSocket from 'ws';
const ws = new WebSocket('ws://localhost/apim/ws'); // OK
 
ws.on('error', console.error);
let count = 0;
ws.on('open', function open() {
  console.log("Opened");
  ws.send(`Query #${count++}` );
  ws.send(`Query #${count++}` );
});

ws.on('message', function message(data:any) {
  console.log('received: %s', data);
});