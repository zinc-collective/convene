const assert = require("assert").strict;

function assertDisplayed(component) {
  return component
    .isDisplayed()
    .then((result) => assert(result, `${component.selector}`));
}
exports.assertDisplayed = assertDisplayed;
