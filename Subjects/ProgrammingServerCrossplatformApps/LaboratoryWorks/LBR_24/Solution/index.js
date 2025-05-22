const express = require ('express') ;
const {createClient} = require('webdav');

const app = express();
const port = 3000;

const client = createClient('', {
    username:'Maxim',
    password:'1337R1337R02192318Uiw'
});

const Error408 = (res, message) => res.status(408).send(`${message}`);
const Error404 = (res, message) => res.status(404).send(`${message}`);

app.post('/md/:createDir', async (req, res) => {
    const dir = req.params.createDir;

    if (client.exists(dir)) {
        Error408('There is already directory with name ' + dir);
    }
    else {
        await client.createDirectory(dir);
        res.status(200).send('Directory successfully created');
    }
        
});

app.post('/rd/:delDir', async (req, res) => {
    const dir = req.params.delDir;

    if (!client.exists(dir)) {
        Error408('There is no directory with name ' + dir);
    }
    else {
        await client.deleteFile(dir);
        res.status(200).send('Directory successfully deleted');
    }

});

app.post('/up/saveFile', (req, res) => {

});
app.post('/down/:fileName', (req, res) => {

});
app.post('/del/:fileName', (req, res) => {

});
app.post('/copy/:fileNameFrom/:fileNameTo', (req, res) => {

});
app.post('/move/:fileNameFrom/:fileNameTo', (req, res) => {

});
app.listen(port, () => {
    console.log("Сервер запущен и работает на локальном хосте на порту " + port);
});


       




