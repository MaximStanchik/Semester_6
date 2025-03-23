const rpcClient = require('rpc-websockets').Client;
let ws = new rpcClient('ws://localhost:4000/');

ws.on('open', () => {
    console.log('Client is connected to the server.');

    const calculate = async () => {
        try {
            const loginResult = await ws.login({ login: 'user', password: '*' });
            if (!loginResult) {
                throw new Error('Authentication failed');
            }
            else {
                console.log('User logged in. Calling protected methods.');

                const square1 = await ws.call('square', [3]);
                console.log('square called with: 3');
                console.log(`Result of square[3] = ${square1}`);
    
                const square2 = await ws.call('square', [5, 4]);
                console.log('square called with: 5, 4');
                console.log(`Result of square[5, 4] = ${square2}`);
    
                const sum1 = await ws.call('sum', [2]);
                console.log('sum called with:', [2]);
                console.log(`Result of sum = ${sum1}`);
    
                const sum2 = await ws.call('sum', [2,4,6,8,10]);
                console.log('sum called with: 2, 4, 6, 8, 10');
                console.log(`Result of sum = ${sum2}`);

                const mul1 = await ws.call('mul', [3]);
                console.log('mul called with: 3');
                console.log(`Result of mul[3] = ${mul1}`);
    
                const mul2 = await ws.call('mul', [3, 5, 7, 9, 11, 13]);
                console.log('mul called with: 3, 5, 7, 9, 11, 13');
                console.log(`Result of mul[3, 5, 7, 9, 11, 13] = ${mul2}`);

                const fib1 = await ws.call('fib', [1]);
                console.log('fib called with: 1');
                console.log(`Result of fib[1] = ${fib1}`);
    
                const fib2 = await ws.call('fib', [2]);
                console.log('fib called with: 2');
                console.log(`Result of fib[2] = ${fib2}`);
    
                const fib3 = await ws.call('fib', [7]);
                console.log('fib called with: 7');
                console.log(`Result of fib[7] = ${fib3}`);

                const fact1 = await ws.call('fact', [0]);
                console.log('fact called with: 0');
                console.log(`Result of fact[2] = ${fact1}`);
    
                const fact2 = await ws.call('fact', [5]);
                console.log('fact called with: 5');
                console.log(`Result of fact[5] = ${fact2}`);

                const fact3 = await ws.call('fact', [10]);
                console.log('fact called with: 10');
                console.log(`Result of fact[10] = ${fact3}`);
            }
        } 
        catch (error) {
            console.error('Error during execution:', error);
        } 
        finally {
            ws.close();
        }
    };

    calculate();
});