const express = require('express');
const https = require('https');
const fs = require('fs');
const path = require('path');

const app = express();

const options = {
    key: fs.readFileSync(path.join(__dirname, 'certificate', 'LAB.key')).toString(),
    cert: fs.readFileSync(path.join(__dirname, 'certificate', 'LAB.crt')).toString(),
    passphrase: 'pass'
}

app.get('/', (req, res) => {
    res.status(200).send('Hello world!');
})

https.createServer(options, app).listen(3443, () => console.log(`Server running at https://sma:3443`));