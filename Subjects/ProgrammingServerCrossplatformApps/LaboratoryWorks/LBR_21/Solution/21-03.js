const express = require('express');
const passport = require('passport');
const LocalStrategy = require('passport-local').Strategy;
const bodyParser = require('body-parser');
const session = require('express-session');
const users = require('./users.json'); // JSON-файл с учетными данными

const app = express();
const PORT = 3000;

// Настройка стратегии аутентификации (LocalStrategy для формы)
passport.use(new LocalStrategy(
  (username, password, done) => {
    const user = users.find(u => u.username === username && u.password === password);
    if (!user) {
      return done(null, false, { message: 'Invalid credentials' });
    }
    return done(null, user);
  }
));

// Сериализация и десериализация пользователя для сессий
passport.serializeUser((user, done) => {
  done(null, user.username);
});

passport.deserializeUser((username, done) => {
  const user = users.find(u => u.username === username);
  done(null, user);
});

// Middleware для парсинга данных формы
app.use(bodyParser.urlencoded({ extended: false }));

// Настройка сессий
app.use(session({
  secret: 'yourSecretKey', // Секретный ключ для сессий
  resave: false,
  saveUninitialized: true
}));

// Middleware для инициализации passport
app.use(passport.initialize());
app.use(passport.session());

// Защищённый маршрут для аутентификации
const authenticate = passport.authenticate('local', { successRedirect: '/resource', failureRedirect: '/login' });

// GET /login (форма для логина)
app.get('/login', (req, res) => {
  // Проверка, если пользователь уже аутентифицирован
  if (req.isAuthenticated()) {
    return res.redirect('/resource');
  }
  res.send(`
    <form method="POST" action="/login">
      <label>Username:</label>
      <input type="text" name="username" required><br>
      <label>Password:</label>
      <input type="password" name="password" required><br>
      <button type="submit">Login</button>
    </form>
  `);
});

// POST /login (обработка данных формы и аутентификация)
app.post('/login', passport.authenticate('local', { successRedirect: '/resource', failureRedirect: '/login' }));

// GET /logout (выход)
app.get('/logout', (req, res) => {
  req.logout((err) => {
    if (err) {
      return res.status(500).send('Error during logout');
    }
    res.redirect('/login');
  });
});

// GET /resource (защищённый ресурс)
app.get('/resource', (req, res) => {
  if (!req.isAuthenticated()) {
    return res.redirect('/login'); // Перенаправление на /login, если пользователь не аутентифицирован
  }
  res.send('RESOURCE');
});

// Обработчик несуществующих маршрутов (404)
app.use((req, res) => {
  res.status(404).send('Not Found');
});

app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
