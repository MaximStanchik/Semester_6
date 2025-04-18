const { ApolloServer } = require('apollo-server');
const schema = require('./schema');
const sequelize = require('./models').sequelize;

const server = new ApolloServer({
    schema,
});

sequelize.sync({ force: false })
    .then(() => {
        server.listen({ port: 3000 }).then(({ url }) => {
            console.log(`Server is running on ${url}`);
        });
    })
    .catch(err => {
        console.error('Unable to connect to the database:', err);
    });