const { Given, When, Then } = require("cucumber");
const { By, Key, until } = require('selenium-webdriver');
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
  const roomCard = this.driver.findElement(By.css(`[name='${room.name}']`))
  const enterRoomLink = roomCard.findElement(By.linkText("Enter Room"))
  await enterRoomLink.click()
});

Then("the {actor} is placed in the {room}", async function (actor, room) {
  this.driver.wait(until.elementLocated(By.css("[name='jitsiConferenceFrame0']")));

  const jitsiIframe = await this.driver.findElements(By.css("[name='jitsiConferenceFrame0']"))
  assert.equal(jitsiIframe.length, 1, 'Jitsi iframe not found');
});

Then("the {actor} is not placed in the {room}", function (actor, room) {
  // Write code here that turns the phrase above into concrete actions
  return "pending";
});

Then('the {workspace} has a {room}', function (workspace, room) {
  // Write code here that turns the phrase above into concrete actions
  return 'pending';
});
