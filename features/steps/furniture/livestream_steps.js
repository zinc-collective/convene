const { Then } = require("@cucumber/cucumber");
const assert = require("assert").strict;

function assertDisplayed(component) {
  return component
    .isDisplayed()
    .then((result) => assert(result, `${component.selector}`));
}

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
