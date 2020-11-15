const { Given, When, Then } = require("cucumber");
const WorkspacePage = require("../page-objects/WorkspacePage");
const Workspace = require("../parameter-types/workspaces");
const Room = require("../parameter-types/rooms");
const RoomCard = require("../page-objects/page-elements/RoomCard");
const assert = require('assert').strict;

const { By, until } = require('selenium-webdriver');
const RoomSettingPage = require("../page-objects/RoomSettingPage");

Given("a Workspace with {accessLevel} {room}", async function (accessLevel, room) {
  const workspace = new Workspace("System Test");
  this.workspace = new WorkspacePage(this.driver, workspace);
  await this.workspace.enter();
  const lockedRooms = await this.workspace.roomCardsWhere({ accessLevel });
  assert(lockedRooms.length > 0);
});

Given('a Workspace with an {publicityLevel} Room', function (publicityLevel) {
  // Write code here that turns the phrase above into concrete actions
  return 'pending';
});

When("a {actor} unlocks the {room} with {roomKey}", async function (actor, room, roomKey) {
  room.name = "Listed Locked Room 1";
  roomKey = "secret"
  const roomSettingPage = await this.workspace.enterConfigureRoom(room, roomKey);
  await roomSettingPage.unlock();
});

When("a {actor} locks the {room} with {roomKey}", async function (actor, room, roomKey) {
  room.name = "Listed Room 1";
  roomKey = "access code";
  const roomSettingPage = await this.workspace.enterConfigureRoom(room);
  await roomSettingPage.lock(roomKey);
});

When('a {actor} locks the {room} without {roomKey}', async function (actor, room, roomKey) {
  room.name = "Listed Room 2";
  const roomSettingPage = await this.workspace.enterConfigureRoom(room);
  await roomSettingPage.lock('');
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

Then('a {actor} may not enter {accessLevel} {room} after providing {roomKey}', async function (actor, accessLevel, room, roomKey) {
  const lockedRoom = new Room(`Listed ${accessLevel.level} Room 1`);
  await this.workspace.enterRoomWithAccessCode(lockedRoom, 'wrong key');

  // TODO: Encapsulate checking error messages
  const error = By.css("[class='access-code-form__error-message']")
  const errorMsg = await this.driver.wait(until.elementLocated(error));
  assert.equal(await errorMsg.isDisplayed(), true)
});

Then('a {actor} may enter {accessLevel} {room} after providing {roomKey}', async function (actor, accessLevel, room, roomKey) {
  const lockedRoom = new Room(`Listed ${accessLevel.level} Room 1`);
  await this.workspace.enterRoomWithAccessCode(lockedRoom, 'secret');
  const videoPanel = await this.workspace.videoPanel();
  assert(await videoPanel.isDisplayed());
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

Then('the Room {accessLevel}', async function (accessLevel) {
  if (accessLevel.level === 'Locked') {
    const room = new Room('Listed Room 1')
    const roomCard = new RoomCard(this.driver, await this.workspace.findRoomCard(room))
    assert(roomCard.isLocked());

    const page = await roomCard.enterRoom();
    assert(await page.isWaitingRoom());
  }
});

Then('the {actor} is informed they need to set {roomKey} when they are locking a {room}', async function (actor, roomKey, room) {
  const roomSettingPage = new RoomSettingPage(this.driver);
  assert(await roomSettingPage.accessCodeError());
});