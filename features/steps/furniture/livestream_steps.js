import { Then } from "@cucumber/cucumber";
import { assertDisplayed } from "../../support/assertDisplayed.js";
import LiveStreamFurnitureComponent from "../../harness/LiveStreamFurnitureComponent.js";
Then("{a} {string} Livestream is playing {a} {string} channel", function (_a, provider, _a2, channel) {
    return assertDisplayed(new LiveStreamFurnitureComponent(this.driver, {
        provider: provider.toLowerCase(),
        channel: channel.toLowerCase(),
    }));
});
