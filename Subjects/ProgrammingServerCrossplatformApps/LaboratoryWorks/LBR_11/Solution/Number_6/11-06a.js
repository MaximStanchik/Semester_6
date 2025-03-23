const rpcws = require('rpc-websockets').Client;

let ws = new rpcws('ws://localhost:4000');

ws.on('open', () => {
    console.log('Client subscribed to A');
    ws.subscribe('A');

    ws.on('A', data => {
        console.log('on A event: ', data.toString());
    });
});

ws.on('error', (err) => {
    console.error('Connection error:', err);
});