const express = require('express');
const passport = require('passport');
const DigestStrategy = require('passport-http').DigestStrategy;
const users = require('./users.json'); // JSON-файл с учетными данными

const app = express();
const PORT = 3000;

// Настройка стратегии аутентификации
passport.use(new DigestStrategy({ qop: 'auth' },
    (username, done) => {
        const user = users.find(u => u.username === username);
        if (!user) {
            return done(null, false);
        }
        return done(null, user, user.password);
    }
));

const authenticate = passport.authenticate('digest', { session: false });

// GET /login (ввод логина и пароля)
app.get('/login', authenticate, (req, res) => {
    res.send('Authenticated successfully');
});

// GET /logout (выход)
app.get('/logout', (req, res) => {
    res.status(401).send('Logged out');
});

// GET /resource (защищённый ресурс)
app.get('/resource', authenticate, (req, res) => {
    res.send('RESOURCE');
});

// Переадресация неаутентифицированных пользователей на /login
app.use((req, res, next) => {
    if (!req.isAuthenticated || !req.isAuthenticated()) {
        return res.redirect('/login');
    }
    next();
});

// Обработчик несуществующих маршрутов (404)
app.use((req, res) => {
    res.status(404).send('Not Found');
});

app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
