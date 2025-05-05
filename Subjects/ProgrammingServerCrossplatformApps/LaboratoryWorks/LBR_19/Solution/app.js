const express = require("express");
const bodyParser = require("body-parser");
const userRoutes = require("./routes/userRoutes");
const productRoutes = require("./routes/productRoutes");

const app = express();

app.set("view engine", "ejs");

app.use(bodyParser.json());

app.use("/api", userRoutes);
app.use("/api", productRoutes);

app.get("/", (req, res) => {
  res.render("index");
});

app.listen(3000, () => {
  console.log("Server is running on port 3000");
});
