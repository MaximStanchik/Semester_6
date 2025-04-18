const { MongoClient } = require('mongodb');

const url = "mongodb+srv://maximstanchik:hvFYKK10GHDt3cie@lbr15cluster.md69oyi.mongodb.net/?retryWrites=true&w=majority&appName=LBR15Cluster";
const dbName = 'BSTU';

async function seedDatabase() {
    const client = new MongoClient(url, { useUnifiedTopology: true });
    try {
        await client.connect().db(dbName);
        console.log("Connected to database");      
    } 
    catch (error) {
        console.error("Error seeding database:", error);
    } 
    finally {
        await client.close();
    }
}

seedDatabase();