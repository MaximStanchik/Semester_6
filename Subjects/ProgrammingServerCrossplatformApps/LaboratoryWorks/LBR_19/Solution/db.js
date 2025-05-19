const User = require("./models/user");
const Product = require("./models/product");

class DB {
  constructor() {
    this.users = [];
    this.products = [];
    this.userId = 1;
    this.productId = 1;
  }

  async getAllUsers() {
    return this.users;
  }

  async createUser(name, email) {
    const newUser = new User(this.userId++, name, email);
    this.users.push(newUser);
    return newUser;
  }

  async updateUser(id, name, email) {
    const user = this.users.find((u) => u.id === parseInt(id));
    if (!user) return null;
    if (name) user.name = name;
    if (email) user.email = email;
    return user;
  }  

  async deleteUser(id) {
    const index = this.users.findIndex((u) => u.id === parseInt(id));
    if (index === -1) return null;
    const deleted = this.users.splice(index, 1)[0];
    return deleted;
  }

  async getAllProducts() {
    return this.products; 
  }

  async createProduct(name, price) {
    const newProduct = new Product(this.productId++, name, price);
    this.products.push(newProduct);
    return newProduct;
  }

  async updateProduct(id, name, price) {
    const product = this.products.find((p) => p.id === parseInt(id));
    if (!product) return null;
    if (name) product.name = name;
    if (price) product.price = price;
    return product;
  }

  async deleteProduct(id) {
    const index = this.products.findIndex((p) => p.id === parseInt(id));
    if (index === -1) return null;
    const deleted = this.products.splice(index, 1)[0];
    return deleted;
  }
}

const SingletonDB = new DB();
module.exports = { SingletonDB };
