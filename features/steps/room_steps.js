const { Given, When, Then } = require("cucumber");
const WorkspacePage = require("../page-objects/WorkspacePage");
const Workspace = require("../parameter-types/workspaces");
const Room = require("../parameter-types/rooms");
const RoomCard = require("../page-objects/page-elements/RoomCard");
const assert = require('assert').strict;

const { By, until } = require('selenium-webdriver');
const RoomSettingPage = require("../page-objects/RoomSettingPage");

/**
 * Merges extracted parameter types together for convenience within step definitions
 */
function linkParameters({ workspace = new Workspace("System Test"),
                          accessLevel, room }) {
  room.reinitialize({ accessLevel })
  return {
    workspace,
    accessLevel,
    room
  }
}

Given("a Workspace with {accessLevel} {room}", async function (accessLevel, room) {
  let { workspace } = linkParameters({ accessLevel, room })
  this.workspace = new WorkspacePage(this.driver, workspace);
  await this.workspace.enter();
  const matchingRooms = await this.workspace.roomCardsWhere({ accessLevel });
  assert(matchingRooms.length > 0);
});

Given('a Workspace with an {publicityLevel} Room', function (publicityLevel) {
  // Write code here that turns the phrase above into concrete actions
  return 'pending';
});

When("a {actor} unlocks {accessLevel} {room} with {accessCode}", async function (actor, accessLevel, room, accessCode) {
  linkParameters({ room, accessLevel })
  const roomConfigurationPage = await this.workspace.enterConfigureRoom(room);
  await roomConfigurationPage.unlock(accessCode);
});

When("a {actor} locks {accessLevel} {room} with {accessCode}", async function (actor, accessLevel, room, accessCode) {
  linkParameters({ room, accessLevel })
  const roomSettingPage = await this.workspace.enterConfigureRoom(room);
  await roomSettingPage.lock(accessCode);
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

Then('a {actor} may enter the Room without providing {accessCode}', function (actor, accessCode) {
  // Write code here that turns the phrase above into concrete actions
  return 'pending';
});

Then('a {actor} may not enter {accessLevel} {room} after providing {accessCode}', async function (actor, accessLevel, room, accessCode) {
  linkParameters({ room, accessLevel })
  await this.workspace.enterRoomWithAccessCode(room, accessCode);

  // TODO: Encapsulate checking error messages
  const error = By.css("[class='access-code-form__error-message']")
  const errorMsg = await this.driver.wait(until.elementLocated(error));
  assert.equal(await errorMsg.isDisplayed(), true)
});

Then('a {actor} may enter {accessLevel} {room} after providing {accessCode}', async function (actor, accessLevel, room, accessCode) {
  console.log({ accessLevel, room })
  linkParameters({ room, accessLevel, accessCode })
  await this.workspace.enterRoomWithAccessCode(room, accessCode);

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

Then('the {actor} is informed they need to set {accessCode} when they are locking a {room}', async function (actor, accessCode, room) {
  const roomSettingPage = new RoomSettingPage(this.driver);
  assert(await roomSettingPage.accessCodeError());
});