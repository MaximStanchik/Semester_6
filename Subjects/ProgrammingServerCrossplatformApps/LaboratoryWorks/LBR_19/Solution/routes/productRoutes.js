const express = require("express");
const router = express.Router();
const pc = require("../controllers/productController");
const db = require("../db");

const controller = new pc.ProductController(db.SingletonDB);

router.get("/products", controller.getAllProducts);
router.post("/products", controller.createProduct);
router.put("/products/:id", controller.updateProduct);
router.delete("/products/:id", controller.deleteProduct);

module.exports = router;
