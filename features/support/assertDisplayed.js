import assert$0 from "assert";
const assert = assert$0.strict;
function assertDisplayed(component) {
  return component
    .isDisplayed()
    .then((result) => assert(result, `${component.selector}`));
}
function refuteDisplayed(component) {
  return component
    .isDisplayed()
    .then((result) => assert(!result, `${component.selector}`));
}
export { assertDisplayed };
export { refuteDisplayed };
