import Component from "./Component.js";
class FurnitureComponent extends Component {
    constructor(driver, furniture) {
        super(driver, furniture.selector);
        this.furniture = furniture;
    }
}
export { FurnitureComponent };
