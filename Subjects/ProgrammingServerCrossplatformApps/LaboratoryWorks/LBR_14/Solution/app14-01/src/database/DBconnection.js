const sql = require('mssql');

class DB_controller {
    constructor() {
        this.config = {
            server: 'localhost',
            database: 'SMA',
            user: 'SA',
            password: 'StrongP@ssw0rd',
            port: 1433,
            options: {
                encrypt: false,
                trustServerCertificate: true
            },
            pool: {
                max: 10,
                min: 0,
                idleTimeoutMillis: 30000
            }
        };

        this.pool = null;
    }

    async client_connect() {
        try {
            this.pool = await sql.connect(this.config);
            console.log('Успешное подключение к базе данных');
            return this.pool;
        }
        catch (e) {
            console.error('Ошибка подключения к базе данных', e.stack);
            throw e;
        }
    }

    async call_query(qry) {
        if (!this.pool) {
            throw new Error('Подключение к базе данных не установлено');
        }

        try {
            const request = this.pool.request();
            let result = await request.query(qry);
            return result;
        }
        catch (e) {
            console.error('Ошибка выполнения запроса', e.stack);
            throw e;
        }
    }

    async close_connection() {
        if (this.pool) {
            await this.pool.close();
            this.pool = null;
            console.log('Подключение закрыто');
        }
    }
}

module.exports = DB_controller;