const TelegramBot = require('node-telegram-bot-api');

const token = '7822987319:AAEXJq9KDGkoDiJDMV6UVTseSzpMBwiAqP8';

const bot = new TelegramBot(token, { polling: true });

bot.onText(/\/start/, (msg) => {
    const chatId = msg.chat.id;
    bot.sendMessage(chatId, 'Привет! Я эхо-бот. Напиши мне что-нибудь, и я повторю.');
  });

bot.on('message', (msg) => {
    const chatId = msg.chat.id;
    const text = msg.text;

    if (!text) {
        return bot.sendMessage(chatId, 'Пожалуйста, отправьте текст.');
    }

    bot.sendMessage(chatId, 'Echo: ' + text);
});

console.log('Бот запущен...');