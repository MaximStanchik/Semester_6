const rpcClient = require('rpc-websockets').Client;
let ws = new rpcClient('ws://localhost:4000/');

ws.on('open', () => {
    ws.login({ login: 'user', password: '*' })
        .then(async () => await calculate()).then(() => ws.close());
});

async function calculate() {
    const square1 = await ws.call('square', [3]);
    console.log('square called with: [3]');
    console.log(`Result of square[3] = ${square1}`);

    const square2 = await ws.call('square', [5, 4]);
    console.log('square called with: [5, 4]');
    console.log(`Result of square[5, 4] = ${square2}`);

    const mul1 = await ws.call('mul', [3, 5, 7, 9, 11, 13]);
    console.log('mul called with: [3, 5, 7, 9, 11, 13]');
    console.log(`Result of mul[3, 5, 7, 9, 11, 13] = ${mul1}`);

    const sum = await ws.call('sum', [square1, square2, mul1]);
    console.log('sum called with:', [square1, square2, mul1]);
    console.log(`Result of sum = ${sum}`);

    const fib = await ws.call('fib', [7]);
    console.log('fib called with: [7]');
    console.log(`Result of fib[7] = ${JSON.stringify(fib)}`);

    const mul2 = await ws.call('mul', [2, 4, 6]);
    console.log('mul called with: [2, 4, 6]');
    console.log(`Result of mul[2, 4, 6] = ${mul2}`);

    const result = sum + fib.slice(-1) * mul2;
    console.log('\nFinal result = ' + result);
}