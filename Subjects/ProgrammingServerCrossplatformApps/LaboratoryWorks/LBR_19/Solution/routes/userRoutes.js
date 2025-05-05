const express = require("express");
const us = require("../controllers/userController");
const db = require("../db");

const router = express.Router();

const controller = new us.UserController(db.SingletonDB);

router.get("/users", controller.getAllUsers);
router.post("/users", controller.createUser);
router.put("/users/:id", controller.updateUser);
router.delete("/users/:id", controller.deleteUser);

module.exports = router;
