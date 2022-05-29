const Component = require('./Component');

class FurnitureComponent extends Component {

  constructor(driver, furniture) {
    super(driver, furniture.selector);
    this.furniture = furniture;
  }
}
exports.FurnitureComponent = FurnitureComponent;
