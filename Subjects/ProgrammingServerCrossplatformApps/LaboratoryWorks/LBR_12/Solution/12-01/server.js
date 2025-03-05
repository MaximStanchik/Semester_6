const http = require('http');
const fs = require('fs'); 
const fsPromises = require('fs').promises; 
const url = require('url');
const path = require('path');
const WebSocket = require('ws');

const PORT = 3000;

const wss = new WebSocket.Server({ noServer: true });
let clients = [];

const server = http.createServer(function(request, response) {
    const parsedUrl = url.parse(request.url, true);

    if (request.method === 'GET') {
        if (parsedUrl.pathname === '/') {
            fs.readFile(path.join(__dirname, 'StudentList.json'), 'utf8', (err, data) => {
                if (err) {
                    response.writeHead(500, { 'Content-Type': 'text/plain; charset=utf-8' });
                    response.end('Ошибка чтения файла');
                    return;
                }
                response.writeHead(200, { 'Content-Type': 'application/json; charset=utf-8' });
                response.end(data);
            });
        }
        else if (parsedUrl.pathname === '/backup') {
            const directoryPath = path.join(__dirname); 
        
            fs.readdir(directoryPath, (err, files) => {
                if (err) {
                    response.writeHead(500, { 'Content-Type': 'text/plain; charset=utf-8' });
                    response.end('Ошибка чтения директории');
                    return;
                }

                const backupFiles = files.filter(file => file.includes('StudentList') && file.endsWith('.json'));
        
                response.writeHead(200, { 'Content-Type': 'application/json; charset=utf-8' });
                response.end(JSON.stringify(backupFiles)); 
            });
        }
        else if (parsedUrl.pathname.split('/').length === 2) {
            const id = parsedUrl.pathname.split('/')[1]; 
        
            fs.readFile(path.join(__dirname, 'StudentList.json'), 'utf8', (err, data) => {
                if (err) {
                    response.writeHead(500, { 'Content-Type': 'text/plain; charset=utf-8' });
                    response.end('Ошибка чтения файла');
                    return;
                }
        
                const students = JSON.parse(data);
                const student = students.find(s => s.id == id); 
        
                if (student) {
                    response.writeHead(200, { 'Content-Type': 'application/json; charset=utf-8' });
                    response.end(JSON.stringify(student)); 
                } 
                else {
                    response.writeHead(404, { 'Content-Type': 'text/plain; charset=utf-8' });
                    response.end('Студент с таким идентификатором не найден');
                }
            });
        }
        
        else {
            response.writeHead(404, { 'Content-Type': 'text/plain; charset=utf-8' });
            response.end('Для GET-запросов такой pathname не обрабатывается');
        }
    }
    else if (request.method === 'POST') {
        if (parsedUrl.pathname === '/') {
            let body = '';
            request.on('data', chunk => {
                body += chunk.toString();
            });
            request.on('end', async () => {
                try {
                    console.log('Полученные данные:', body);
                    const newStudent = JSON.parse(body);
                    const filePath = path.join(__dirname, 'StudentList.json');

                    try {
                        await fsPromises.access(filePath);
                    } 
                    catch (err) {
                        await fsPromises.writeFile(filePath, JSON.stringify([])); 
                    }

                    const data = await fsPromises.readFile(filePath, 'utf8');
                    const students = JSON.parse(data || '[]');

                    const existingStudent = students.find(student => student.id === newStudent.id);
                    if (existingStudent) {
                        response.writeHead(400, { 'Content-Type': 'application/json' });
                        response.end(JSON.stringify({ error: 'Студент с таким ID уже существует.' }));
                        return;
                    }

                    students.push(newStudent);
                    await fsPromises.writeFile(filePath, JSON.stringify(students, null, 2));

                    response.writeHead(201, { 'Content-Type': 'application/json' });
                    response.end(JSON.stringify(newStudent));
                } catch (error) {
                    console.error('Ошибка:', error);
                    response.writeHead(500, { 'Content-Type': 'application/json' });
                    response.end(JSON.stringify({ error: 'Ошибка сервера.' }));
                }
            });
        }
        else if (parsedUrl.pathname === '/backup') {
            setTimeout(() => {
                const now = new Date();
                const timestamp = `${now.getFullYear()}${String(now.getMonth() + 1).padStart(2, '0')}${String(now.getDate()).padStart(2, '0')}${String(now.getHours()).padStart(2, '0')}${String(now.getMinutes()).padStart(2, '0')}${String(now.getSeconds()).padStart(2, '0')}`;
                const backupFileName = `${timestamp}_StudentList.json`;
                const sourceFilePath = path.join(__dirname, 'StudentList.json');
                const backupFilePath = path.join(__dirname, backupFileName);
        
                fs.copyFile(sourceFilePath, backupFilePath, (err) => {
                    if (err) {
                        response.writeHead(500, { 'Content-Type': 'application/json' });
                        response.end(JSON.stringify({ error: 1, message: 'Ошибка при копировании файла' }));
                        return;
                    }
        
                    response.writeHead(200, { 'Content-Type': 'application/json' });
                    response.end(JSON.stringify({ message: 'Резервная копия создана', backupFileName }));
                });
            }, 2000); 
        }
        else {
            response.writeHead(404, { 'Content-Type': 'text/plain; charset=utf-8' });
            response.end('Для POST-запросов такой pathname не обрабатывается');
        }
    }
    else if (request.method === 'PUT') {
        if (parsedUrl.pathname === '/') {
            let body = '';
            request.on('data', chunk => {
                body += chunk.toString();
            });
            request.on('end', async () => {
                try {
                    const updatedStudent = JSON.parse(body);
                    const filePath = path.join(__dirname, 'StudentList.json');
    
                    const data = await fsPromises.readFile(filePath, 'utf8');
                    const students = JSON.parse(data || '[]');
    
                    const studentIndex = students.findIndex(student => student.id === updatedStudent.id);
                    if (studentIndex === -1) {
                        response.writeHead(404, { 'Content-Type': 'application/json' });
                        response.end(JSON.stringify({ error: 'Студент с таким ID не найден.' }));
                        return;
                    }
    
                    students[studentIndex] = updatedStudent;
                    await fsPromises.writeFile(filePath, JSON.stringify(students, null, 2));
    
                    response.writeHead(200, { 'Content-Type': 'application/json' });
                    response.end(JSON.stringify(updatedStudent));
                } 
                catch (error) {
                    console.error('Ошибка:', error);
                    response.writeHead(500, { 'Content-Type': 'application/json' });
                    response.end(JSON.stringify({ error: 'Ошибка сервера.' }));
                }
            });
        } 
        else {
            response.writeHead(404, { 'Content-Type': 'text/plain; charset=utf-8' });
            response.end('Для PUT-запросов такой pathname не обрабатывается');
        }
    }
    else if (request.method === 'DELETE') {
        const parts = parsedUrl.pathname.split('/');
        
        if (parts.length === 2 && parts[1]) {
            const id = parts[1];
    
            if (!id) {
                response.writeHead(400, { 'Content-Type': 'application/json' });
                response.end(JSON.stringify({ error: 1, message: 'Не указан идентификатор студента' }));
                return;
            }
    
            fs.readFile(path.join(__dirname, 'StudentList.json'), 'utf8', (err, data) => {
                if (err) {
                    response.writeHead(500, { 'Content-Type': 'application/json' });
                    response.end(JSON.stringify({ error: 1, message: 'Ошибка чтения файла' }));
                    return;
                }
    
                const students = JSON.parse(data || '[]');
                const studentIndex = students.findIndex(s => s.id == id);
    
                if (studentIndex === -1) {
                    response.writeHead(404, { 'Content-Type': 'application/json' });
                    response.end(JSON.stringify({ error: 1, message: 'Студент с таким идентификатором не найден' }));
                    return;
                }
    
                const deletedStudent = students.splice(studentIndex, 1)[0];
                fs.writeFile(path.join(__dirname, 'StudentList.json'), JSON.stringify(students, null, 2), (err) => {
                    if (err) {
                        response.writeHead(500, { 'Content-Type': 'application/json' });
                        response.end(JSON.stringify({ error: 1, message: 'Ошибка при обновлении файла' }));
                        return;
                    }
    
                    response.writeHead(200, { 'Content-Type': 'application/json' });
                    response.end(JSON.stringify(deletedStudent));
                });
            });
        }
        else if (parts.length === 3 && parts[1] === 'backup') {
            const dateStr = parts[2];
        
            if (!/^\d{8}$/.test(dateStr)) {
                response.writeHead(400, { 'Content-Type': 'text/plain; charset=utf-8' });
                response.end('Неверный формат даты, ожидается yyyyddmm');
                return;
            }
        
            const targetDate = new Date(`${dateStr.slice(0, 4)}-${dateStr.slice(6, 8)}-${dateStr.slice(4, 6)}`);
        
            if (isNaN(targetDate.getTime())) {
                response.writeHead(400, { 'Content-Type': 'text/plain; charset=utf-8' });
                response.end('Ошибка: не удалось создать дату');
                return;
            }
        
            const backupDir = __dirname; 
        
            fs.readdir(backupDir, (err, files) => {
                if (err) {
                    response.writeHead(500, { 'Content-Type': 'text/plain; charset=utf-8' });
                    response.end('Ошибка чтения директории');
                    return;
                }
        
                const backupFiles = files.filter(file => file.startsWith('StudentList') && file.endsWith('.json') && file !== 'StudentList.json');
        
                const deletePromises = backupFiles.map(file => {
                    const filePath = path.join(backupDir, file);
                    return fs.promises.stat(filePath).then(stats => {
                        if (stats.birthtime < targetDate) {
                            return fs.promises.unlink(filePath)
                                .then(() => console.log(`Удален файл: ${file}`))
                                .catch(err => console.error(`Ошибка при удалении файла ${file}:`, err));
                        } else {
                            console.log(`Файл ${file} не удален, дата создания не старше целевой даты.`);
                        }
                    }).catch(err => {
                        console.error(`Ошибка при получении информации о файле ${file}:`, err);
                    });
                });
        
                Promise.all(deletePromises)
                    .then(() => {
                        response.writeHead(200, { 'Content-Type': 'text/plain; charset=utf-8' });
                        response.end('Старые копии успешно удалены');
                    })
                    .catch(err => {
                        response.writeHead(500, { 'Content-Type': 'text/plain; charset=utf-8' });
                        response.end('Ошибка при удалении файлов');
                    });
            });
        }
    }
    else {
        response.writeHead(404, {'Content-Type': 'text/plain; charset=utf-8'});
        response.end('Обрабатываются только запросы GET, POST, PUT, DELETE');
    }
    
});

wss.on('connection', function(ws) {
    clients.push(ws);
    console.log('Клиент подключен');

    ws.on('close', function() {
        clients = clients.filter(client => client !== ws);
        console.log('Клиент отключен');
    });
});

const filePath = path.join(__dirname, 'StudentList.json');
fs.watchFile(filePath, (curr, prev) => {
    if (curr.mtime !== prev.mtime) {
        console.log('Файл StudentList.json изменен');
        clients.forEach(client => {
            if (client.readyState === WebSocket.OPEN) {
                client.send('Файл StudentList.json изменен');
            }
        });
    }
});

const httpServer = server.listen(PORT, function() {
    console.log('Сервер запущен на http://localhost:' + PORT);
});

httpServer.on('upgrade', function (request, socket, head) {
    wss.handleUpgrade(request, socket, head, function (ws) {
        wss.emit('connection', ws, request);
    });
});