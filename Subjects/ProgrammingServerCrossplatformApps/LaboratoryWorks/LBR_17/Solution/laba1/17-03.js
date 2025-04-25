const redis = require('redis');

const client = redis.createClient({
    url: 'redis://:secret@localhost:6379'
});

client.on('ready',() => {console.log('Ready');});
client.on('error',(err) => console.log('Error: ',err));
client.on('connect',() => console.log('Connect'))
client.on('end',() => console.log('End'));

(async () => {
    await client.connect();

    await client.set('incr', 0);

    console.log("Выполнение 10000 операций incr:");
    let startTime = new Date().getTime();
    for (i = 0; i < 10000; i++) {
        await client.incr('incr');
    }
    let endTime = new Date().getTime();
    console.log(`Incr: ${endTime - startTime}ms`);

    console.log("Выполнение 10000 операций decr:");
    startTime = new Date().getTime();
    for (i = 0; i < 10000; i++) {
        await client.decr('decr');
    }
    endTime = new Date().getTime();
    console.log(`Decr: ${endTime - startTime}ms`);

    await client.quit();
})()