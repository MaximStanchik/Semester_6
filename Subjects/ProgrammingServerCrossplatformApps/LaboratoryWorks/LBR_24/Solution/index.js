const express = require('express');
const fs = require('fs');

const app = express();
const port = 3000;

const Error408 = (res, message) => res.status(408).send(`${message}`);
const Error404 = (res, message) => res.status(404).send(`${message}`);

(async () => {
    const { createClient } = await import('webdav');
    const client = createClient('https://webdav.yandex.ru', { username: 's7.44ax@yandex.by', password: 'hatumntjlzjlmtwc' });

    app.post('/md/:name', (req, res) => {
        const nameFile = `/${req.params.name}`;
        client.exists(nameFile).then(result => {
            if (!result) {
                client.createDirectory(nameFile);
                res.status(200).send('Directory succesfully created.');
            }
            else {
                Error408(res, `Failed to create folder with name = ${req.params.name}.`);
            }
            
        });
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

    app.post('/up/:name', (req, res) => {
        try {
            const filePath = req.params.name;

            if (!fs.existsSync(filePath)) {
                Error404(res, `There is no file with name = ${req.params.name}.`);
                return;
            }

            let rs = fs.createReadStream(filePath);
            let ws = client.createWriteStream(req.params.name);
            rs.pipe(ws);
            res.status(200).send('File uploaded successfully.');
        }
        catch (err) {
            Error408(res, `Cannot upload file: ${err.message}.`);
        }
    });

    app.post('/down/:fileName', async (req, res) => {
        const filePath = req.params.fileName;

        if (!(await client.exists(filePath))) {
            Error404(res, "There is no file with name " + filePath);
        } else {
            try {
                let rs = client.createReadStream(filePath);
                let ws = fs.createWriteStream(Date.now() + '_' + filePath);
                rs.pipe(ws);
                rs.pipe(res);
            } catch (err) {
                Error404(res, "Can't download file " + filePath + ". Error: " + err);
            }
        }
    });

    app.post('/del/:fileName', async (req, res) => {
        const fileName = req.params.fileName;
        try {
            if (!(await client.exists(fileName))) {
                Error404(res, "There is no file with name " + fileName);
            } else {
                await client.deleteFile(fileName);
                res.status(200).send('File deleted successfully.');
            }
        }
        catch (err) {
            console.error("Error deleting file:", err);
            Error404(res, "Can't delete file. Error: " + err);
        }
    });
    app.post('/copy/:fileNameFrom/:fileNameTo', async (req, res) => {
        const fileNameFrom = req.params.fileNameFrom;
        const fileNameTo = req.params.fileNameTo;
    
        if (!await client.exists(fileNameFrom)) {
            return Error404(res, "There is no file with name " + fileNameFrom);
        }
    
        if (await client.exists(fileNameTo)) {
            return res.status(400).send('File already exists: ' + fileNameTo);
        }
    
        try {
            await client.copyFile(fileNameFrom, fileNameTo);
            res.status(200).send('File copied successfully to ' + fileNameTo);
        } catch (err) {
            console.error("Copy error:", err);
            return Error404(res, "Can't copy file. Error: " + err);
        }
    });

    app.post('/move/:fileNameFrom/:fileNameTo', async (req, res) => {
        const fileNameFrom = req.params.fileNameFrom;

        if (!client.exists(fileNameFrom)) {
            Error404(res, "There is no file with name " + fileNameFrom);
        }
        else {
            const fileNameTo = req.params.fileNameTo;
            try {
                client.moveFile(fileNameFrom, fileNameTo);
                res.status(200).send('File moved successfully.');
            }
            catch (err) {
                Error404(res, "Can't move file. Error: " + err);
            }
        }
    });

    app.listen(port, () => {
        console.log("Сервер запущен и работает на локальном хосте на порту " + port);
    });
})();









