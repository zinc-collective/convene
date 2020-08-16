const { Given, When, Then } = require("cucumber");
const assert = require('assert').strict;

Given("a Workspace with a {accessLevel} {room}", function (accessLevel, room) {
  // Write code here that turns the phrase above into concrete actions
  return "pending";
});

When("a {actor} provides the wrong {room} Key", function (actor, room) {
  // Write code here that turns the phrase above into concrete actions
  return "pending";
});

When("a {actor} provides the correct {room} Key", function (actor, room) {
  // Write code here that turns the phrase above into concrete actions
  return "pending";
});

When('the {actor} taps the {room} in the Room Picker', async function (actor, room) {
  await this.workspace.enterRoom(room);
});

Then("the {actor} is placed in the {room}", async function (actor, room) {
  const videoPanel = await this.workspace.videoPanel();
  assert(await videoPanel.isDisplayed());
});

Then("the {actor} is not placed in the {room}", function (actor, room) {
  // Write code here that turns the phrase above into concrete actions
  return "pending";
});

Then('the {workspace} has a {room}', function (workspace, room) {
  // Write code here that turns the phrase above into concrete actions
  return 'pending';
});
