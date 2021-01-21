const { Given, When, Then } = require("cucumber");
const SpacePage = require("../page-objects/SpacePage");
const Space = require("../parameter-types/spaces");
const Room = require("../parameter-types/rooms");
const RoomCard = require("../page-objects/page-elements/RoomCard");
const assert = require('assert').strict;

const { By, until } = require('selenium-webdriver');
const RoomSettingPage = require("../page-objects/RoomSettingPage");

/**
 * Merges extracted parameter types together for convenience within step definitions
 */
function linkParameters({ space = new Space("System Test"),
                          accessLevel, room }) {
  room.reinitialize({ accessLevel })
  return {
    space,
    accessLevel,
    room
  }
}

Given("a Space with {accessLevel} {room}", async function (accessLevel, room) {
  let { space } = linkParameters({ accessLevel, room })
  this.space = new SpacePage(this.driver, space);
  await this.space.enter();
  const matchingRooms = await this.space.roomCardsWhere({ accessLevel });
  assert(matchingRooms.length > 0);
});

Given('a Space with an {publicityLevel} Room', function (publicityLevel) {
  // Write code here that turns the phrase above into concrete actions
  return 'pending';
});

When("a {actor} unlocks {accessLevel} {room} with {accessCode}", async function (actor, accessLevel, room, accessCode) {
  linkParameters({ room, accessLevel })
  const roomConfigurationPage = await this.space.enterConfigureRoom(room);
  await roomConfigurationPage.unlock(accessCode);
});

When("a {actor} locks {accessLevel} {room} with {accessCode}", async function (actor, accessLevel, room, accessCode) {
  linkParameters({ room, accessLevel })
  const roomSettingPage = await this.space.enterConfigureRoom(room);
  await roomSettingPage.lock(accessCode);
});

When('the {actor} taps the {room} in the Room Picker', async function (actor, room) {
  await this.space.enterRoom(room);
});

Then("the {actor} is placed in the {room}", async function (actor, room) {
  const videoPanel = await this.space.videoPanel();
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
  await this.space.enterRoomWithAccessCode(room, accessCode);

  // TODO: Encapsulate checking error messages
  const error = By.css("[class='access-code-form__error-message']")
  const errorMsg = await this.driver.wait(until.elementLocated(error));
  assert.equal(await errorMsg.isDisplayed(), true)
});

Then('a {actor} may enter {accessLevel} {room} after providing {accessCode}', async function (actor, accessLevel, room, accessCode) {
  linkParameters({ room, accessLevel, accessCode })
  await this.space.enterRoomWithAccessCode(room, accessCode);

  const videoPanel = await this.space.videoPanel();
  assert(await videoPanel.isDisplayed());
});

Then('the {space} has a {room}', function (space, room) {
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
  return this.space.findRoomCard(room, false).then((ok) => {
    throw `We found a door for ${room.name} that we did not want to find`
  }).catch((e) => {
    if(e.name === 'NoSuchElementError') { return true }
    throw e
  });
});

Then('the Room {accessLevel}', async function (accessLevel) {
  const room = new Room("")
  linkParameters({ room, accessLevel })
  if (accessLevel.level === 'Locked') {
    const roomCard = new RoomCard(this.driver, room)
    assert(await roomCard.isLocked());

    const page = await roomCard.enterRoom();
    assert(await page.isWaitingRoom());
  }
});

Then('the {actor} is informed they need to set {accessCode} when they are locking a {room}', async function (actor, accessCode, room) {
  const roomSettingPage = new RoomSettingPage(this.driver);
  assert(await roomSettingPage.accessCodeError());
});
