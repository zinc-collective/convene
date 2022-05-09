const { Then } = require("@cucumber/cucumber");
const assert = require("assert").strict;

const LiveStreamFurnitureComponent = require("../../harness/LiveStreamFurnitureComponent");
Then(
  "{a} Livestream is playing {a} {string} OwnCast Channel",
  function (a, a2, channel) {
    // Write code here that turns the phrase above into concrete actions
    return new LiveStreamFurnitureComponent(this.driver, { provider: "owncast", channel  })
      .isDisplayed()
      .then(assert);
  }
);

Then(
  "{a} Livestream is playing {a} {string} Twitch Channel",
  function (a, a2, channel) {
    // Write code here that turns the phrase above into concrete actions
    return new LiveStreamFurnitureComponent(this.driver, { provider: 'twitch', channel })
      .isDisplayed()
      .then(assert);
  }
);
