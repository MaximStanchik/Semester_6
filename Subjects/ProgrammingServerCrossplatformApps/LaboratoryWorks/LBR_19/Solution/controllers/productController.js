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
    res.send(products);
  };

  createProduct = async (req, res) => {
    const { name, price } = req.body;
    let product = await this.db.createProduct(name, price);
    res.send(product);
  };

  updateProduct = async (req, res) => {
    const { id } = req.params;
    const { name, price } = req.body;
  
    let product = await this.db.updateProduct(id, name, price);
    if (!product) {
      return res.status(404).json({ message: "Product not found" });
    }
    res.send(product);
  };
  

  deleteProduct = async (req, res) => {
    const { id } = req.params;
    let product = await this.db.deleteProduct(id);
    res.send((product));
  };
}

module.exports = { ProductController };
