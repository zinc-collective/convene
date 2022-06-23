import Component from "./Component.js";
class LiveStreamFurnitureComponent extends Component {
    constructor(driver, { provider, channel }) {
        super(driver, `*[data-furniture-kind="livestream"][data-provider="${provider}"]`);
        this.provider = provider;
        this.channel = channel;
    }
}
export default LiveStreamFurnitureComponent;
