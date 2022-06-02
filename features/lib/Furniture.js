const Model = require("./Model");

class Furniture extends Model {
  constructor({ type }) {
    super();
    this.type = type;
  }
}

module.exports = Furniture;
