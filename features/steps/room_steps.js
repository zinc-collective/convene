const { Given, When, Then } = require("cucumber");
const assert = require('assert').strict;

Given("a Workspace with {accessLevel} {room}", function (accessLevel, room) {
  // Write code here that turns the phrase above into concrete actions
  return "pending";
});

Given('a Workspace with an {publicityLevel} Room', function (publicityLevel) {
  // Write code here that turns the phrase above into concrete actions
  return 'pending';
});

When("a {actor} unlocks the {room} with {roomKey}", function (actor, room) {
  // Write code here that turns the phrase above into concrete actions
  return "pending";
});

When("a {actor} locks the {room} with {roomKey}", function (actor, room) {
  // Write code here that turns the phrase above into concrete actions
  return "pending";
});

When('a {actor} locks the {room} without {roomKey}', function (actor, room, roomKey) {
  // Write code here that turns the phrase above into concrete actions
  return 'pending';
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

Then('a {actor} may enter the Room without providing {roomKey}', function (actor, roomKey) {
  // Write code here that turns the phrase above into concrete actions
  return 'pending';
});

Then('a {actor} may not enter the {room} after providing {roomKey}', function (actor, room, roomKey) {
  // Write code here that turns the phrase above into concrete actions
  return 'pending';
});

Then('a {actor} may enter the {room} after providing {roomKey}', function (actor, room, roomKey) {
  // Write code here that turns the phrase above into concrete actions
  return 'pending';
});

Then('the {workspace} has a {room}', function (workspace, room) {
  // Write code here that turns the phrase above into concrete actions
  return 'pending';
});


Then('the {actor} does not see the {room}\'s Door', function (actor, room) {
  // We bypass the wait for the room door, and if we _do_ find it,
  // something has gone horribly wrong, so we're going to raise an
  // exception and fail the test.
  // If it _does not_ find the roomCard, then everything is beautiful;
  // all is right with the world; and we pass the assertion.
  //
  // TODO: Figure out a way to do this that doesn't require changing the
  //       find methods on our page objects!
  return this.workspace.findRoomCard(room, false).then((ok) => {
    throw `We found a door for ${room.name} that we did not want to find`
  }).catch((e) => {
    if(e.name === 'NoSuchElementError') { return true }
    throw e
  });
});

Then('the Room is {accessLevel}', function (accessLevel) {
  // Write code here that turns the phrase above into concrete actions
  return 'pending';
});

Then('the {actor} is informed they need to set {roomKey} when they are locking a {room}', function (actor, roomKey, room) {
  // Write code here that turns the phrase above into concrete actions
  return 'pending';
});