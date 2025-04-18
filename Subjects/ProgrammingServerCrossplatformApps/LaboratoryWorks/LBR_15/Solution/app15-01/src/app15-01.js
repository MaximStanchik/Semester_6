const http = require('http');
const url = require('url');
const { MongoClient, ObjectId } = require('mongodb');

const PORT = 3000;
const mongoUrl = "mongodb+srv://maximstanchik:hvFYKK10GHDt3cie@lbr15cluster.md69oyi.mongodb.net/?retryWrites=true&w=majority&appName=LBR15Cluster";
const dbName = 'BSTU';

let db;

async function connectToDatabase() {
    const client = new MongoClient(mongoUrl, { useUnifiedTopology: true });
    try {
        await client.connect();
        db = client.db(dbName);
        console.log('Connected to database');
    } 
    catch (error) {
        console.error("Connection failed:", error);
    }
}

async function handleRequest(req, res) {
    const parsedUrl = url.parse(req.url, true);
    const pathName = parsedUrl.pathname;

    res.setHeader('Content-Type', 'application/json');

    try {
        switch (req.method) {
            case 'GET': {
                if (pathName === '/api/faculties') {
                    const faculties = await db.collection('faculty').find().toArray();
                    res.end(JSON.stringify(faculties));
                } 
                else if (pathName === '/api/pulpits') {
                    const pulpits = await db.collection('pulpit').find().toArray();
                    res.end(JSON.stringify(pulpits));
                } 
                else {
                    res.statusCode = 404;
                    res.end(JSON.stringify({ error: "Not found" }));
                }
                break;
            }
            case 'POST': {
                let body = '';
                req.on('data', chunk => {
                    body += chunk.toString();
                });
                req.on('end', async () => {
                    try {
                        const data = JSON.parse(body);
                        
                        const existingFaculty = await db.collection('faculty').findOne({ faculty: data.faculty });
                        if (!existingFaculty) {
                            res.statusCode = 400; 
                            res.end(JSON.stringify({ error: "Faculty does not exist" }));
                            return;
                        }
            
                        if (pathName === '/api/faculties') {
                            const existingFaculty = await db.collection('faculty').findOne({ faculty: data.faculty });
                            if (existingFaculty) {
                                res.statusCode = 409; 
                                res.end(JSON.stringify({ error: "Faculty already exists" }));
                                return;
                            }
                            const result = await db.collection('faculty').insertOne(data);
                            res.statusCode = 201; 
                            res.end(JSON.stringify(result.ops[0]));
                        } else if (pathName === '/api/pulpits') {
                            const existingPulpit = await db.collection('pulpit').findOne({ pulpit: data.pulpit });
                            if (existingPulpit) {
                                res.statusCode = 409; 
                                res.end(JSON.stringify({ error: "Pulpit already exists" }));
                                return;
                            }
                            const result = await db.collection('pulpit').insertOne(data);
                            res.statusCode = 201; 
                            res.end(JSON.stringify(result.ops[0]));
                        } else {
                            res.statusCode = 404;
                            res.end(JSON.stringify({ error: "Not found" }));
                        }
                    } catch (error) {
                        res.statusCode = 400;
                        res.end(JSON.stringify({ error: "Invalid JSON" }));
                    }
                });
                break;
            }
            case 'PUT': {
                let body = '';
                req.on('data', chunk => {
                    body += chunk.toString();
                });
                req.on('end', async () => {
                    try {
                        const data = JSON.parse(body); 
                        
                        if (!data._id) {
                            res.statusCode = 400; 
                            res.end(JSON.stringify({ error: "ID is required" }));
                            return;
                        }
                        
                        if (pathName === '/api/faculties') {
                            const result = await db.collection('faculty').updateOne(
                                { _id: new ObjectId(data._id) },
                                { $set: { faculty: data.faculty, faculty_name: data.faculty_name } }
                            );
                            res.end(JSON.stringify(result));
                        } 
                        else if (pathName === '/api/pulpits') {
                            const existingFaculty = await db.collection('faculty').findOne({ faculty: data.faculty });
                            if (!existingFaculty) {
                                res.statusCode = 400; 
                                res.end(JSON.stringify({ error: "Faculty does not exist" }));
                                return;
                            }
            
                            const result = await db.collection('pulpit').updateOne(
                                { _id: new ObjectId(data._id) },
                                { $set: { pulpit: data.pulpit, pulpit_name: data.pulpit_name, faculty: data.faculty } }
                            );
                            res.end(JSON.stringify(result));
                        } 
                        else {
                            res.statusCode = 404; 
                            res.end(JSON.stringify({ error: "Not found" }));
                        }
                    } 
                    catch (error) {
                        console.error("Error parsing JSON:", error); 
                        res.statusCode = 400; 
                        res.end(JSON.stringify({ error: "Invalid JSON" }));
                    }
                });
                break;
            }
            case 'DELETE': {
                const id = parsedUrl.pathname.split('/')[3];
                try {
                    if (pathName.startsWith('/api/faculties/')) {
                        const facultyToDelete = await db.collection('faculty').findOne({ _id: new ObjectId(id) });
                        if (facultyToDelete) {
                            await db.collection('pulpit').deleteMany({ faculty: facultyToDelete.faculty });
                        }
            
                        const result = await db.collection('faculty').deleteOne({ _id: new ObjectId(id) });
                        res.end(JSON.stringify(result));
                    } 
                    else if (pathName.startsWith('/api/pulpits/')) {
                        const result = await db.collection('pulpit').deleteOne({ _id: new ObjectId(id) });
                        res.end(JSON.stringify(result));
                    } 
                    else {
                        res.statusCode = 404;
                        res.end(JSON.stringify({ error: "Not found" }));
                    }
                } catch (error) {
                    res.statusCode = 500;
                    res.end(JSON.stringify({ error: "Error deleting item" }));
                }
                break;
            }
            default: {
                res.statusCode = 405;
                res.end(JSON.stringify({ error: "Method not allowed" }));
                break;
            }
        }
    } 
    catch (error) {
        console.error("Error handling request:", error);
        res.statusCode = 500;
        res.end(JSON.stringify({ error: "Internal server error" }));
    }
}

const server = http.createServer(handleRequest);

connectToDatabase().then(() => {
    server.listen(PORT, () => {
        console.log(`Server is running on http://localhost:${PORT}`);
    });
});