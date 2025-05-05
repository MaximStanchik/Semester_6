const User = require("./models/user");
const Product = require("./models/product");

class DB {
  constructor() {}

  async getAllUsers() {
    return "Получение всех пользователей";
  }

  async createUser(name, email) {
    const newUser = new User(1, name, email);
    return "Создание нового пользователя: " + name + " " + email;
  }

  async updateUser(id) {
    return "Обновление пользователя с ID: " + id;
  }

  async deleteUser(id) {
    return "Удаление пользователя с ID: " + id;
  }

  async getAllProducts() {
    return "Получение всех продуктов";
  }

  async createProduct(name, price) {
    const newProduct = new Product(1, name, price);
    return "Создание нового продукта: " + name + " " + price;
  }

  async updateProduct(id) {
    return "Обновление продукта с ID: " + id;
  }

  async deleteProduct(id) {
    return "Удаление продукта с ID: " + id;
  }
}

const SingletonDB = new DB();

module.exports = { SingletonDB };
