const { Then } = require("@cucumber/cucumber");

const { assertDisplayed } = require("../../support/assertDisplayed");
const LiveStreamFurnitureComponent = require("../../harness/LiveStreamFurnitureComponent");


Then(
  "{a} {string} Livestream is playing {a} {string} channel",
  function (_a, provider, _a2, channel) {
    return assertDisplayed(
      new LiveStreamFurnitureComponent(this.driver, {
        provider: provider.toLowerCase(),
        channel: channel.toLowerCase(),
      })
    );
  }
);
