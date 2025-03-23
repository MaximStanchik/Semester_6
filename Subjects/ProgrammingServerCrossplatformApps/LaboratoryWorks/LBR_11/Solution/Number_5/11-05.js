const rpcServer = require('rpc-websockets').Server;
const server = new rpcServer({port: 4000, host: 'localhost'});

// Установка аутентификации
server.setAuth(l => l.login === 'user' && l.password === '*');

// Регистрация метода sum
server.register('sum', params => {
    console.log('sum called with:', params);
    let sum = params.reduce((a, b) => a + b, 0);
    console.log('Sum:', sum);
    return sum;
}).public();

// Регистрация метода mul
server.register('mul', params => {
    console.log('mul called with:', params);
    let mul = params.reduce((a, b) => a * b, 1);
    console.log('mul:', mul);
    return mul;
}).public();

// Регистрация метода square
server.register('square', params => {
    console.log('square called with:', params);
    if (params.length === 1) {
        return params[0] * params[0];
    }
    if (params.length === 2) {
        return Math.PI * (params[0] ** 2);
    }
    console.log('Invalid parameters for square:', params);
    return null;
}).public();

// Регистрация метода fib
server.register('fib', params => {
    console.log('fib called with:', params);
    const n = params[0];
    const result = fibonacciSequence(n);
    console.log('fib:', result);
    return result;
}).public(); // Сделаем его публичным для отладки

// Регистрация метода fact
server.register('fact', params => {
    console.log('fact called with:', params);
    if (params.length !== 1) {
        console.log('Returning 1 due to incorrect parameters');
        return 1; 
    }
    const result = factorial(params[0]);
    console.log('fact result:', result);
    return result; 
}).public(); // Сделаем его публичным для отладки

// Функция для вычисления факториала
function factorial(n) {
    if (n < 0) return undefined;
    if (n === 0 || n === 1) return 1;
    return n * factorial(n - 1);
}

// Функция для вычисления последовательности Фибоначчи
function fibonacciSequence(n) {
    let sequence = [];
    if (n === 1) {
        sequence.push(0);
    } else if (n >= 2) {
        sequence = [0, 1];
        for (let i = 2; i < n; i++) {
            const nextElement = sequence[i - 1] + sequence[i - 2];
            sequence.push(nextElement);
        }
    }
    return sequence;
}

// Запуск сервера
server.on('connection', () => console.log('Client connected'));
server.on('request', req => console.log('Request received:', req));
server.on('close', () => console.log('Server closed'));