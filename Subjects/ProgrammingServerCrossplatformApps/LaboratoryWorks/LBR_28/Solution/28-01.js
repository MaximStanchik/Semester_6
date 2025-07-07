const express = require('express');
const bodyParser = require('body-parser');
const swaggerUi = require('swagger-ui-express');
const swaggerDocument = require('./swagger.json');
const fs = require('fs');

const port = 3000;
const app = express();

app.use(bodyParser.json());
app.use('/swagger', swaggerUi.serve, swaggerUi.setup(swaggerDocument));

let phonebook = JSON.parse(fs.readFileSync('phone.json', 'utf8'));

app.get('/TD', (req, res) => {
    res.json(phonebook);
});

app.get('/TD/:id', (req, res) => {
    const id = parseInt(req.params.id);

    if (!Number.isInteger(id) || id <= 0) {
        return res.status(400).json({ message: 'ID должен быть положительным целым числом, больше нуля' });
    }

    const contact = phonebook.find(contact => contact.id === id);
    if (contact) {
        res.json(contact);
    } else {
        res.status(404).json({ message: 'Контакт не найден' });
    }
});

app.post('/TD', (req, res) => {
    const { id, name, number } = req.body;

    if (!id || !name || !number) {
        return res.status(400).json({ message: 'ID, имя и номер обязательны' });
    }

    if (!Number.isInteger(id) || id <= 0) {
        return res.status(400).json({ message: 'ID должен быть положительным целым числом, больше нуля' });
    }

    if (phonebook.some(contact => contact.id === id)) {
        return res.status(400).json({ message: 'Контакт с таким ID уже существует' });
    }

    if (phonebook.some(contact => contact.number === number)) {
        return res.status(400).json({ message: 'Контакт с таким номером уже существует' });
    }

    const newContact = { id, name, number };
    phonebook.push(newContact);
    fs.writeFileSync('phone.json', JSON.stringify(phonebook, null, 2));
    res.json(newContact);
});

app.post('/TD', (req, res) => {
    const { id, name, number } = req.body;
  
    if (id === undefined || name === undefined || number === undefined) {
      return res.status(400).json({ message: 'ID, имя и номер обязательны' });
    }
  
    if (!Number.isInteger(id) || id <= 0) {
      return res.status(400).json({ message: 'ID должен быть положительным целым числом, больше нуля' });
    }
  
    if (phonebook.some(contact => contact.id === id)) {
      return res.status(400).json({ message: 'Контакт с таким ID уже существует' });
    }
  
    if (phonebook.some(contact => contact.number === number)) {
      return res.status(400).json({ message: 'Контакт с таким номером уже существует' });
    }
  
    const newContact = { id, name, number };
    phonebook.push(newContact);
    fs.writeFileSync('phone.json', JSON.stringify(phonebook, null, 2));
    res.json(newContact);
  });

app.delete('/TD/:id', (req, res) => {
    const id = parseInt(req.params.id);
    if (id === undefined) {
        return res.status(400).json({ message: 'Необходимо ввести ID' });
      }
      if (!Number.isInteger(id) || id <= 0) {
        return res.status(400).json({ message: 'ID должен быть положительным целым числом, больше нуля' });
      }
    const index = phonebook.findIndex(contact => contact.id === id);
    if (index !== -1) {
        phonebook.splice(index, 1);
        fs.writeFileSync('phone.json', JSON.stringify(phonebook, null, 2));
        res.json({ message: 'Контакт успешно удален' });
    } else {
        res.status(404).json({ message: 'Контакт не найден' });
    }
});

app.listen(port, () => { console.log(`Server is running on port ${port}`);});