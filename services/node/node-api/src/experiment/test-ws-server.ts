import { WebSocketServer, WebSocket } from 'ws';


const  WS_PORT=3003
const ws = new WebSocketServer({ port: WS_PORT });


ws.on('listening', (ws: WebSocket)=> {
    console.log('Listening for websocket connexion on port', WS_PORT)

});

let count = 0;
ws.on('connection', (ws: WebSocket)=> {
    ws.on('error', console.error);

    ws.on('message', function message(data) {
        console.log('Server received: %s', data);
        sendMessage(ws);
    });
});

ws.on('upgrade', (request, socket, head) => {
    console.log("Ugrade")
    socket.on('error', console.error);
  
    // This function is not defined on purpose. Implement it with your own logic.
    
      ws.handleUpgrade(request, socket, head, function done(ws) {
        ws.emit('connection', ws, request, client);
      });
    
  });

function sendMessage(ws: WebSocket, limit = 5, sent=0){
    if (sent<limit){
        ws.send(`Message from server${count++}`)
        setTimeout(() =>  {
            sendMessage(ws, limit, sent+1)
        }, 1500)
    }
}

