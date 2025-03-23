const rpcws = require('rpc-websockets').Server;

let server = new rpcws({ port: 4000, host: 'localhost' });

server.event('A');
server.event('B');
server.event('C');

process.stdin.setEncoding('utf-8');
process.stdin.on('readable', function () {
    let data = null;
    while ((data = process.stdin.read()) != null) {
        switch (data.trim().toUpperCase()) {
            case 'A':
                console.log('Emitting event A');
                server.emit('A', 'event A');
                break;
            case 'B':
                console.log('Emitting event B');
                server.emit('B', 'event B');
                break;
            case 'C':
                console.log('Emitting event C');
                server.emit('C', 'event C');
                break;
        }
    }
});

server.on('connection', (client) => {
    console.log('Client connected');
});