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
    res.send(this.getHtml(users));
  };

  createUser = async (req, res) => {
    const { name, email } = req.body;
    let user = await this.db.createUser(name, email);
    res.send(this.getHtml(user));
  };

  updateUser = async (req, res) => {
    const { id } = req.params;
    let user = await this.db.updateUser(id);
    res.send(this.getHtml(user));
  };

  deleteUser = async (req, res) => {
    const { id } = req.params;
    let user = await this.db.deleteUser(id);
    res.send(this.getHtml(user));
  };
}

module.exports = { UserController };
