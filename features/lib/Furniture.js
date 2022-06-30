import Model from "./Model.js";
class Furniture extends Model {
  constructor({ type }) {
    super();
    this.type = type;
  }
}
export default Furniture;
