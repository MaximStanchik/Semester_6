const net = require('net');
const HOST = '127.0.0.1';
const PORT = 4000;

let server = net
    .createServer((socket) => {
        console.log(
            `\nClient connected: ${socket.remoteAddress}:${socket.remotePort}`
        );

        socket.on('data', (data) => {
            console.log(`Server received: ${data}`);
            socket.write(`ECHO: ${data}`);
            socket.destroy();
        });

        socket.on('close', () => {
            console.log(`Connection closed.`);
        });
        socket.on('error', (error) => {
            console.log('[ERROR] Client: ' + error.message);
        });
    })
    .listen(PORT, HOST);

server.on('error', (error) => {
    console.log('[ERROR] Server: ' + error.message);
});



// особенность лабы -- поенадобится лаба, https надо везде, делается в парах. один генерит сертификат, другой генерит ключ. ЛИБО два ноутбука одного человека ЛИБО свой ноут и виртуалка. 
//ЛИБО два разных человека. Поэтому SSL (лаба 23 не делаем) убираем, 25 тоже убираем, 20 тоже не делаем. 