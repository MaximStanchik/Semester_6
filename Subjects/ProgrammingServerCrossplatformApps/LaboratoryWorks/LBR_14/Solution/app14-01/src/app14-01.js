const http = require('http');
const url = require('url');
const fs = require('fs');
const path = require('path');
const DB_controller = require('./database/DBconnection');
const db = new DB_controller();
const PORT = 3000;

async function startServer() {
    await db.client_connect();

    const server = http.createServer(async (req, res) => {
        const parsedUrl = url.parse(req.url, true);
        try {
            switch (req.method) {
                case 'GET': {
                    await handleGetRequest(parsedUrl, res);
                    break;
                }
                case 'POST': {
                    await handlePostRequest(parsedUrl, req, res);
                    break;
                }
                case 'PUT': {
                    await handlePutRequest(parsedUrl, req, res);
                    break;
                }
                case 'DELETE': {
                    await handleDeleteRequest(parsedUrl, req, res);
                    break;
                }
                default: {
                    res.statusCode = 405;
                    res.end(JSON.stringify({ error: "Method not allowed" }));
                }
            }
        }
        catch (error) {
            console.error(error);
            res.statusCode = 500;
            res.end(JSON.stringify({ error: "Internal server error" }));
        }
    });

    server.listen(PORT, () => {
        console.log("Сервер запущен на порту " + PORT);
    });
}

async function handleGetRequest(parsedUrl, res) {
    const pathName = parsedUrl.pathname;

    switch (pathName) {
        case '/': {
            fs.readFile(path.join(__dirname, 'static', 'main.html'), (err, data) => {
                if (err) {
                    res.writeHead(500);
                    return res.end('Error loading main.html');
                }
                res.writeHead(200, { 'Content-Type': 'text/html' });
                res.end(data);
            });
            break;
        }
        case '/api/faculties': {
            const faculties = await db.call_query('SELECT * FROM FACULTY');
            res.end(JSON.stringify(faculties.recordset));
            break;
        }
        case '/api/pulpits': {
            const pulpits = await db.call_query('SELECT * FROM PULPIT');
            res.end(JSON.stringify(pulpits.recordset));
            break;
        }
        case '/api/subjects': {
            const subjects = await db.call_query('SELECT * FROM SUBJECT');
            res.end(JSON.stringify(subjects.recordset));
            break;
        }
        case '/api/auditoriumstypes': {
            const auditoriumTypes = await db.call_query('SELECT * FROM AUDITORIUM_TYPE');
            res.end(JSON.stringify(auditoriumTypes.recordset));
            break;
        }
        case '/api/auditoriums': {
            const auditoriums = await db.call_query('SELECT * FROM AUDITORIUM');
            res.end(JSON.stringify(auditoriums.recordset));
            break;
        }
        default: {
            res.statusCode = 404;
            res.end(JSON.stringify({ error: "Not found" }));
        }
    }
}

async function handlePostRequest(parsedUrl, req, res) {
    const path = parsedUrl.pathname;
    let body = '';
    
    req.on('data', chunk => {
        body += chunk.toString();
    });

    req.on('end', async () => {
        if (!body) {
            res.statusCode = 400;
            return res.end(JSON.stringify({ error: "No data provided" }));
        }

        let data;
        try {
            data = JSON.parse(body);
        } catch (error) {
            res.statusCode = 400;
            return res.end(JSON.stringify({ error: "Invalid JSON" }));
        }

        try {
            switch (path) {
                case '/api/faculties': {
                    if (!data.FACULTY || !data.FACULTY_NAME) {
                        res.statusCode = 400;
                        return res.end(JSON.stringify({ error: "FACULTY and FACULTY_NAME are required" }));
                    }

                    if (data.FACULTY.length > 10) {
                        res.statusCode = 400;
                        return res.end(JSON.stringify({ error: "Код факультета не должен превышать 10 символов" }));
                    }

                    const existingFaculty = await db.call_query(`SELECT * FROM FACULTY WHERE FACULTY = N'${data.FACULTY}'`);
                    if (existingFaculty.recordset.length > 0) {
                        res.statusCode = 400;
                        return res.end(JSON.stringify({ error: "Факультет с таким кодом уже существует" }));
                    }

                    await db.call_query(`INSERT INTO FACULTY (FACULTY, FACULTY_NAME) VALUES (N'${data.FACULTY}', N'${data.FACULTY_NAME}')`);
                    return res.end(JSON.stringify({ success: true }));
                }

                case '/api/pulpits': {
                    if (!data.PULPIT || !data.PULPIT_NAME || !data.FACULTY) {
                        res.statusCode = 400;
                        return res.end(JSON.stringify({ error: "PULPIT, PULPIT_NAME and FACULTY are required" }));
                    }

                    if (data.PULPIT.length > 10) {
                        res.statusCode = 400;
                        return res.end(JSON.stringify({ error: "Код кафедры не должен превышать 10 символов" }));
                    }

                    const facultyCheck = await db.call_query(`SELECT * FROM FACULTY WHERE FACULTY = N'${data.FACULTY}'`);
                    if (facultyCheck.recordset.length === 0) {
                        res.statusCode = 400;
                        return res.end(JSON.stringify({ error: "Указанный факультет не существует" }));
                    }

                    const existingPulpit = await db.call_query(`SELECT * FROM PULPIT WHERE PULPIT = N'${data.PULPIT}'`);
                    if (existingPulpit.recordset.length > 0) {
                        res.statusCode = 400;
                        return res.end(JSON.stringify({ error: "Кафедра с таким кодом уже существует" }));
                    }

                    await db.call_query(`INSERT INTO PULPIT (PULPIT, PULPIT_NAME, FACULTY) VALUES (N'${data.PULPIT}', N'${data.PULPIT_NAME}', N'${data.FACULTY}')`);
                    return res.end(JSON.stringify({ success: true }));
                }

                case '/api/subjects': {
                    if (!data.SUBJECT || !data.SUBJECT_NAME || !data.PULPIT) {
                        res.statusCode = 400;
                        return res.end(JSON.stringify({ error: "SUBJECT, SUBJECT_NAME and PULPIT are required" }));
                    }

                    if (data.SUBJECT.length > 10) {
                        res.statusCode = 400;
                        return res.end(JSON.stringify({ error: "Код дисциплины не должен превышать 10 символов" }));
                    }

                    const pulpitCheck = await db.call_query(`SELECT * FROM PULPIT WHERE PULPIT = N'${data.PULPIT}'`);
                    if (pulpitCheck.recordset.length === 0) {
                        res.statusCode = 400;
                        return res.end(JSON.stringify({ error: "Указанная кафедра не существует" }));
                    }

                    const existingSubject = await db.call_query(`SELECT * FROM SUBJECT WHERE SUBJECT = N'${data.SUBJECT}'`);
                    if (existingSubject.recordset.length > 0) {
                        res.statusCode = 400;
                        return res.end(JSON.stringify({ error: "Дисциплина с таким кодом уже существует" }));
                    }

                    await db.call_query(`INSERT INTO SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT) VALUES (N'${data.SUBJECT}', N'${data.SUBJECT_NAME}', N'${data.PULPIT}')`);
                    return res.end(JSON.stringify({ success: true }));
                }

                case '/api/auditoriumstypes': {
                    if (!data.AUDITORIUM_TYPE || !data.AUDITORIUM_TYPENAME) {
                        res.statusCode = 400;
                        return res.end(JSON.stringify({ error: "AUDITORIUM_TYPE and AUDITORIUM_TYPENAME are required" }));
                    }

                    if (data.AUDITORIUM_TYPE.length > 10) {
                        res.statusCode = 400;
                        return res.end(JSON.stringify({ error: "Код типа аудитории не должен превышать 10 символов" }));
                    }

                    const existingAudType = await db.call_query(`SELECT * FROM AUDITORIUM_TYPE WHERE AUDITORIUM_TYPE = N'${data.AUDITORIUM_TYPE}'`);
                    if (existingAudType.recordset.length > 0) {
                        res.statusCode = 400;
                        return res.end(JSON.stringify({ error: "Тип аудитории с таким кодом уже существует" }));
                    }

                    await db.call_query(`INSERT INTO AUDITORIUM_TYPE (AUDITORIUM_TYPE, AUDITORIUM_TYPENAME) VALUES (N'${data.AUDITORIUM_TYPE}', N'${data.AUDITORIUM_TYPENAME}')`);
                    return res.end(JSON.stringify({ success: true }));
                }

                case '/api/auditoriums': {
                    if (!data.AUDITORIUM || !data.AUDITORIUM_NAME || !data.AUDITORIUM_TYPE || data.AUDITORIUM_CAPACITY === undefined) {
                        res.statusCode = 400;
                        return res.end(JSON.stringify({ error: "AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE and AUDITORIUM_CAPACITY are required" }));
                    }

                    if (data.AUDITORIUM.length > 10) {
                        res.statusCode = 400;
                        return res.end(JSON.stringify({ error: "Код аудитории не должен превышать 10 символов" }));
                    }

                    const auditoriumTypeCheck = await db.call_query(`SELECT * FROM AUDITORIUM_TYPE WHERE AUDITORIUM_TYPE = N'${data.AUDITORIUM_TYPE}'`);
                    if (auditoriumTypeCheck.recordset.length === 0) {
                        res.statusCode = 400;
                        return res.end(JSON.stringify({ error: "Указанный тип аудитории не существует" }));
                    }

                    const existingAuditorium = await db.call_query(`SELECT * FROM AUDITORIUM WHERE AUDITORIUM = N'${data.AUDITORIUM}'`);
                    if (existingAuditorium.recordset.length > 0) {
                        res.statusCode = 400;
                        return res.end(JSON.stringify({ error: "Аудитория с таким кодом уже существует" }));
                    }

                    await db.call_query(`INSERT INTO AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY) VALUES (N'${data.AUDITORIUM}', N'${data.AUDITORIUM_NAME}', N'${data.AUDITORIUM_TYPE}', ${data.AUDITORIUM_CAPACITY})`);
                    return res.end(JSON.stringify({ success: true }));
                }

                default: {
                    res.statusCode = 404;
                    return res.end(JSON.stringify({ error: "Not found" }));
                }
            }
        } catch (error) {
            console.error('Error processing request:', error);
            res.statusCode = 500;
            return res.end(JSON.stringify({ 
                error: "Internal server error",
                details: error.message 
            }));
        }
    });
}
            

async function handlePutRequest(parsedUrl, req, res) {
    const path = parsedUrl.pathname;
    let body = '';

    req.on('data', chunk => {
        body += chunk.toString();
    });

    req.on('end', async () => {
        console.log(`Received PUT request for ${path}`);

        try {
            const data = JSON.parse(body);
            
            switch (path) {
                case '/api/faculties': {

                    const faculty = data.FACULTY;
                    const facultyName = data.FACULTY_NAME;

                    if (!faculty || !facultyName) {
                        res.statusCode = 400;
                        return res.end(JSON.stringify({ error: "FACULTY and FACULTY_NAME are required" }));
                    }

                    const result = await db.call_query(`UPDATE FACULTY SET FACULTY_NAME = N'${facultyName}' WHERE FACULTY = N'${faculty}'`);

                    if (result.rowsAffected[0] === 0) {
                        res.statusCode = 404;
                        res.end(JSON.stringify({ error: "Faculty not found" }));
                    } 
                    else {
                        res.end(JSON.stringify({ success: true }));
                    }
                    break;
                }
                case '/api/pulpits': {
                    const pulpit = data.PULPIT;
                    const pulpitName = data.PULPIT_NAME;
                    const faculty = data.FACULTY;

                    if (!pulpit || !pulpitName || !faculty) {
                        res.statusCode = 400;
                        return res.end(JSON.stringify({ error: "PULPIT, FACULTY and PULPIT_NAME are required" }));
                    }

                    const facultyCheck = await db.call_query(`SELECT * FROM FACULTY WHERE FACULTY = N'${faculty}'`);
                    if (facultyCheck.recordset.length === 0) {
                        res.statusCode = 400;
                        return res.end(JSON.stringify({ error: "FACULTY not found" }));
                    }

                    const result = await db.call_query(`UPDATE PULPIT SET PULPIT_NAME = N'${pulpitName}', FACULTY = N'${faculty}' WHERE PULPIT = N'${pulpit}'`);
                    if (result.rowsAffected[0] === 0) {
                        res.statusCode = 404;
                        res.end(JSON.stringify({ error: "Pulpit not found" }));
                    } else {
                        res.end(JSON.stringify({ success: true }));
                    }
                    break;
                }

                case '/api/subjects': {
                    const pulpit = data.PULPIT;
                    const subject = data.SUBJECT;
                    const subjectName = data.SUBJECT_NAME;
                
                    if (!pulpit || !subject || !subjectName) {
                        res.statusCode = 400;
                        return res.end(JSON.stringify({ error: "PULPIT, SUBJECT and SUBJECT_NAME are required" }));
                    }
                
                    try {
                        const pulpitCheck = await db.call_query(`SELECT * FROM PULPIT WHERE PULPIT = N'${pulpit}'`);
                        if (pulpitCheck.recordset.length === 0) {
                            res.statusCode = 400; 
                            return res.end(JSON.stringify({ error: "PULPIT not found" }));
                        }
                
                        const result = await db.call_query(`UPDATE SUBJECT SET SUBJECT_NAME = N'${subjectName}', PULPIT = N'${pulpit}' WHERE SUBJECT = N'${subject}'`);
                
                        if (result.rowsAffected[0] === 0) {
                            res.statusCode = 404;
                            res.end(JSON.stringify({ error: "Subject not found" }));
                        } 
                        else {
                            res.end(JSON.stringify({ success: true }));
                        }
                    } 
                    catch (error) {
                        console.error("Error processing request:", error);
                        res.statusCode = 500;
                        res.end(JSON.stringify({ error: "Internal server error" }));
                    }
                    break;
                }
                case '/api/auditoriumstypes': {
                    const audTypeName = data.AUDITORIUM_TYPENAME;
                    const audType = data.AUDITORIUM_TYPE;

                    if (!audType || !audTypeName) {
                        res.statusCode = 400;
                        return res.end(JSON.stringify({ error: "PULPIT, SUBJECT and SUBJECT_NAME are required" }));
                    }

                    const result = await db.call_query(`UPDATE AUDITORIUM_TYPE SET AUDITORIUM_TYPENAME = N'${audTypeName}' WHERE AUDITORIUM_TYPE = N'${audType}'`);

                    if (result.rowsAffected[0] === 0) {
                        res.statusCode = 404;
                        res.end(JSON.stringify({ error: "Pulpit not found" }));
                    } 
                    else {
                        res.end(JSON.stringify({ success: true }));
                    }
                    break;
                }
                case '/auditoriums': {
                    const aud = data.AUDITORIUM;
                    const audCap = data.AUDITORIUM_CAPACITY;
                    const audType = data.AUDITORIUM_TYPE;
                    const audName = data.AUDITORIUM_NAME;

                    if (!aud || !audCap || !audType || !audName) {
                        res.statusCode = 400;
                        return res.end(JSON.stringify({ error: "AUDITORIUM, AUDITORIUM_CAPACITY, AUDITORIUM_TYPE and AUDITORIUM_NAME are required" }));
                    }

                    const result = await db.call_query(`UPDATE AUDITORIUM SET AUDITORIUM_NAME = N'${audName}', AUDITORIUM_TYPE = N'${audType}', AUDITORIUM_CAPACITY = ${audCap} WHERE AUDITORIUM = N'${aud}'`);
                    
                    if (result.rowsAffected[0] === 0) {
                        res.statusCode = 404;
                        res.end(JSON.stringify({ error: "Pulpit not found" }));
                    } 
                    else {
                        res.end(JSON.stringify({ success: true }));
                    }
                    break;
                }
                default: {
                    res.statusCode = 404;
                    res.end(JSON.stringify({ error: "Not found" }));
                }
            }
        } catch (error) {
            console.error("Error processing request:", error);
            res.statusCode = 400;
            res.end(JSON.stringify({ error: "Invalid JSON" }));
        }
    });
}

async function handleDeleteRequest(parsedUrl, req, res) {
    const fullPath = parsedUrl.pathname;

    if (fullPath.startsWith('/api/faculties/')) {
        const id = decodeURIComponent(fullPath.split('/')[3]);
        const existingFaculty = await db.call_query(`SELECT * FROM FACULTY WHERE FACULTY = N'${id}'`);
        if (existingFaculty.recordset.length === 0) {
            res.statusCode = 404;
            return res.end(JSON.stringify({ error: "Faculty not found" }));
        }

        await db.call_query(`DELETE FROM FACULTY WHERE FACULTY = N'${id}'`);
        res.end(JSON.stringify({ success: true }));
    }
    else if (fullPath.startsWith('/api/pulpits/')) {
        const id = decodeURIComponent(fullPath.split('/')[3]);
        const existingPulpit = await db.call_query(`SELECT * FROM PULPIT WHERE PULPIT = N'${id}'`);
        if (existingPulpit.recordset.length === 0) {
            res.statusCode = 404;
            return res.end(JSON.stringify({ error: "Pulpit not found" }));
        }

        await db.call_query(`DELETE FROM PULPIT WHERE PULPIT = N'${id}'`);
        res.end(JSON.stringify({ success: true }));
    }
    else if (fullPath.startsWith('/api/subjects/')) {
        const id = decodeURIComponent(fullPath.split('/')[3]);
        const existingSubject = await db.call_query(`SELECT * FROM SUBJECT WHERE SUBJECT = N'${id}'`);
        if (existingSubject.recordset.length === 0) {
            res.statusCode = 404;
            return res.end(JSON.stringify({ error: "Subject not found" }));
        }

        await db.call_query(`DELETE FROM SUBJECT WHERE SUBJECT = N'${id}'`);
        res.end(JSON.stringify({ success: true }));
    }
    else if (fullPath.startsWith('/api/auditoriumtypes/')) {
        const id = decodeURIComponent(fullPath.split('/')[3]);
        const existingSubject = await db.call_query(`SELECT * FROM AUDITORIUM_TYPE WHERE AUDITORIUM_TYPE = N'${id}'`);
        if (existingSubject.recordset.length === 0) {
            res.statusCode = 404;
            return res.end(JSON.stringify({ error: "Auditorium type not found" }));
        }

        await db.call_query(`DELETE FROM AUDITORIUM_TYPE WHERE AUDITORIUM_TYPE = N'${id}'`);
        res.end(JSON.stringify({ success: true }));
    }
    else if (fullPath.startsWith('/api/auditoriums/')) {
        const id = decodeURIComponent(fullPath.split('/')[3]);
        const existingAud = await db.call_query(`SELECT * FROM AUDITORIUM WHERE AUDITORIUM = N'${id}'`);
        if (existingAud.recordset.length === 0) {
            res.statusCode = 404;
            return res.end(JSON.stringify({ error: "Auditorium type not found" }));
        }

        await db.call_query(`DELETE FROM AUDITORIUM WHERE AUDITORIUM = N'${id}'`);
        res.end(JSON.stringify({ success: true }));
    }
    else {
        res.statusCode = 404;
        res.end(JSON.stringify({ error: "Not found" }));
    }

}

startServer();
