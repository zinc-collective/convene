const Model = require("./Model");

class Furniture extends Model {
  constructor({ type }) {
    super();
    this.type = type;
  }

  attributes() {
    return { type: this.type }
  }
}

module.exports = Furniture;
