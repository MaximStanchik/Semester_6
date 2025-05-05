const express = require('express');
const passport = require('passport');
const BasicStrategy = require('passport-http').BasicStrategy;
const users = require('./users.json'); // JSON-файл с учетными данными

const app = express();
const PORT = 3000;

// Настройка стратегии аутентификации
passport.use(new BasicStrategy((username, password, done) => {
    const user = users.find(u => u.username === username && u.password === password);
    if (!user) {
        return done(null, false);
    }
    return done(null, user);
}));

// Middleware для аутентификации
const authenticate = passport.authenticate('basic', { session: false });

// Маршрут для входа (GET /login)
app.get('/login', authenticate, (req, res) => {
    res.send('Authenticated successfully');
});

// Маршрут для выхода (GET /logout)
app.get('/logout', (req, res) => {
    res.status(401).send('Logged out');
});

// Защищенный ресурс (GET /resource)
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

// Обработчик для остальных URI (404)
app.use((req, res) => {
    res.status(404).send('Not Found');
});

app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
