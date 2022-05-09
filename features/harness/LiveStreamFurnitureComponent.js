const Component = require("./Component");
class LiveStreamFurnitureComponent extends Component {
  constructor(driver, { provider, channel }) {
    super(driver, `*[data-furniture-kind="livestream"][data-provider="${provider}"]` )

    this.provider = provider;
    this.channel = channel;
  }
}

module.exports = LiveStreamFurnitureComponent;
