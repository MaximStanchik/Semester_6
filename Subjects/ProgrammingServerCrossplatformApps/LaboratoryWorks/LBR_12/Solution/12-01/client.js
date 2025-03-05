const WebSocket = require('ws');

let socket;

function startWebSocket() {
    socket = new WebSocket('ws://localhost:3000'); 

    socket.on('open', function () {
        console.log('WebSocket connection established');
    });

    socket.on('message', function (data) {
        console.log('Сообщение от сервера: ', data.toString());
    });

    socket.on('error', function (error) {
        console.error('Ошибка сокета: ', error);
    });

    socket.on('close', function () {
        console.log('Подключение сокета закрыто');
    });
}

startWebSocket();