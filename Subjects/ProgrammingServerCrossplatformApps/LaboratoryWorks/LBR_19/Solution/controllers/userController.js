class UserController {
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

  getAllUsers = async (req, res) => {
    let users = await this.db.getAllUsers();
    res.send(users);
  };

  createUser = async (req, res) => {
    const { name, email } = req.body;
    let user = await this.db.createUser(name, email);
    res.send((user));
  };

  updateUser = async (req, res) => {
    const { id } = req.params;
    const { name, email } = req.body;
  
    let user = await this.db.updateUser(id, name, email);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }
    res.send(user);
  };
  

  deleteUser = async (req, res) => {
    const { id } = req.params;
    let user = await this.db.deleteUser(id);
    res.send((user));
  };
}

module.exports = { UserController };
