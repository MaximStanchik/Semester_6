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
    
    console.log("Выполнение 10000 операций set:");
    let startTime = new Date().getTime();
    for (i = 0; i < 10000; i++) {
        await client.set(`key${i}`, `value${i}`);
    }
    let endTime = new Date().getTime();
    console.log(`Set: ${endTime - startTime}ms`);

    console.log("Выполнение 10000 операций get:");
    startTime = new Date().getTime();
    for (i = 0; i < 10000; i++) {
        await client.get(`key${i}`);
    }
    endTime = new Date().getTime();
    console.log(`Get: ${endTime - startTime}ms`);

    console.log("Выполнение 10000 операций del:");
    startTime = new Date().getTime();
    for (i = 0; i < 10000; i++) {
        await client.del(`key${i}`);
    }
    endTime = new Date().getTime();
    console.log(`Del: ${endTime - startTime}ms`);

    await client.quit();
})()