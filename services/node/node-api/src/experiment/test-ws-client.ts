import WebSocket from 'ws';

/*
{
  "uri": "/ws",
  "name": "ws",
  "desc": "Test ws integration",
  "upstream": {
    "nodes": [
      {
        "host": "avenirs-node",
        "port": 3003,
        "weight": 1
      }
    ],
    "timeout": {
      "connect": 6,
      "send": 6,
      "read": 6
    },
    "type": "roundrobin",
    "scheme": "http",
    "pass_host": "pass",
    "keepalive_pool": {
      "idle_timeout": 60,
      "requests": 1000,
      "size": 320
    }
  },
  "enable_websocket": true,
  "status": 1
}*/


  const ws = new WebSocket('ws://localhost:10000/notification/ws'); // OK
  //const ws = new WebSocket('ws://localhost/apisix-gw/ws'); // OK
// const ws = new WebSocket('ws://localhost:3003'); // OK

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