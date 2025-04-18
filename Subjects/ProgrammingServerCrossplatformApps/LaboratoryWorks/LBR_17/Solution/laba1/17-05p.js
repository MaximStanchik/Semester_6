const redis = require('redis');

const publisher = redis.createClient({url:'redis://localhost:6379/'});
const subscriber = redis.createClient({url:'redis://localhost:6379/'});

publisher.on('ready', () => { console.log('Publisher ready'); });
publisher.on('error', (err) => console.log('Publisher error: ', err));

subscriber.on('ready', () => { console.log('Subscriber ready'); });
subscriber.on('error', (err) => console.log('Subscriber error: ', err));


subscriber.subscribe('channel1', (message) => {
    console.log('Received message on channel1: ', message);
});

subscriber.subscribe('channel2', (message) => {
    console.log('Received message on channel2: ', message);
});

(async () => {
    await publisher.connect();
    await subscriber.connect();

    setTimeout(async () => {
        await publisher.publish('channel1', 'message1');
    }, 1000);

    const intervalId = setInterval(async () => {
        await publisher.publish('channel1', 'messageXXX');
    }, 2000);

    setTimeout(async () => {
        await publisher.publish('channel2', 'message2');
    }, 3000);

    setTimeout(async () => {
        await publisher.publish('channel1', 'message3');
    }, 7000);

    setTimeout(async () => {
        clearInterval(intervalId); 
        await publisher.quit();
        await subscriber.quit();
    }, 15000);
})();