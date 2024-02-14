process.on('uncaughtException', (error) => {
    console.log('Catched uncaughtException: ', error);
    process.exit(1);
  
  
  })

var kafka : any = require('kafka-node');
// const client: any = new kafka.KafkaClient({kafkaHost: "localhost:29092"});
const client: any = new kafka.KafkaClient({kafkaHost: "localhost:9080"});
client.on('ready',() => {
  console.log('client is ready');
});

client.on('error',(err: any) => {
  console.log('Error client', err);
});


var Consumer = kafka.Consumer,
 
 consumer = new Consumer(
 client, [ { topic: "avenirs-notification", partition: 0 } ]);
consumer.on('message', function (message:any) {
 console.log(message);
});

consumer.on('error', function (err:any) {console.log('Error', err)})
consumer.on('offsetOutOfRange', function (err: any) { console.log('error OffsetOoutOfRange', err)})