class ProductController {
  db;

  getHtml(message) {
    return `
      <div>
        Result: ${message}
      </div>
    `;
  }

  constructor(db) {
    this.db = db;
  }

  getAllProducts = async (req, res) => {
    const products = await this.db.getAllProducts();
    res.send(this.getHtml(products));
  };

  createProduct = async (req, res) => {
    const { name, price } = req.body;
    let product = await this.db.createProduct(name, price);
    res.send(this.getHtml(product));
  };

  updateProduct = async (req, res) => {
    const { id } = req.params;
    let product = await this.db.updateProduct(id);
    res.send(this.getHtml(product));
  };

  deleteProduct = async (req, res) => {
    const { id } = req.params;
    let product = await this.db.deleteProduct(id);
    res.send(this.getHtml(product));
  };
}

module.exports = { ProductController };
