const assert = require("assert").strict;

function assertDisplayed(component) {
  return component
    .isDisplayed()
    .then((result) => assert(result, `${component.selector}`));
}

function refuteDisplayed(component) {
  return component
    .isDisplayed()
    .then((result) => assert(!result, `${component.selector}`))
}
exports.assertDisplayed = assertDisplayed;
exports.refuteDisplayed = refuteDisplayed;
