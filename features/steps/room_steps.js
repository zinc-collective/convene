const { Given, When, Then } = require("cucumber");

const { SpacePage, RoomEditPage, RoomPage } = require("../harness/Pages");
const { RoomCardComponent } = require("../harness/Components");
const { Space, Room, Actor } = require("../lib");

const assert = require("assert").strict;

/**
 * Merges extracted parameter types together for convenience within step definitions
 */
function linkParameters({
  space = new Space("System Test"),
  accessLevel,
  room,
}) {
  room.space = space
  room.reinitialize({ accessLevel });
  return {
    space,
    accessLevel,
    room,
  };
}

Given("a Space with {accessLevel} {room}", async function (accessLevel, room) {
  let { space } = linkParameters({ accessLevel, room });
  this.space = await new SpacePage(this.driver, space).visit();
  const matchingRooms = await this.space.roomCardsWhere({ accessLevel });
  assert(matchingRooms.length > 0);
});

Given("a Space with an {publicityLevel} Room", function (publicityLevel) {
  // Write code here that turns the phrase above into concrete actions
  return "pending";
});

When(
  "a {actor} unlocks {accessLevel} {room} with {accessCode}",
  function (actor, accessLevel, room, accessCode) {
    const { space } = linkParameters({ room, accessLevel });
    return new SpacePage(this.driver, space)
      .visit()
      .then((spacePage) => spacePage.roomCard(room).configure())
      .then((roomSettingsPage) => roomSettingsPage.unlock(accessCode));
  }
);

When(
  "a {actor} locks {accessLevel} {room} with {accessCode}",
  function (actor, accessLevel, room, accessCode) {
    return this.space
      .roomCard(room)
      .configure()
      .then((roomSettingsPage) => roomSettingsPage.lock(accessCode));
  }
);

When("the {actor} taps the {room} in the Room Picker", function (actor, room) {
  return this.space.roomCard(room).enter();
});

Then("the {actor} is placed in the {room}", async function (actor, room) {
  const roomPage = new RoomPage(this.driver, room);
  assert(await roomPage.videoPanel().isDisplayed());
});

Then("the {actor} is not placed in the {room}", function (actor, room) {
  // Write code here that turns the phrase above into concrete actions
  return "pending";
});

Then(
  "a {actor} may enter the Room without providing {accessCode}",
  function (actor, accessCode) {
    // Write code here that turns the phrase above into concrete actions
    return "pending";
  }
);

Then(
  "a {actor} may not enter {accessLevel} {room} after providing {accessCode}",
  async function (actor, accessLevel, room, accessCode) {
    linkParameters({ room, accessLevel });

    await this.driver.manage().deleteAllCookies();

    const waitingRoomPage = await this.space
      .visit()
      .then((spacePage) => spacePage.roomCard(room).enter(accessCode));

    assert(await waitingRoomPage.isWaitingRoom());
    assert(await waitingRoomPage.errors().isDisplayed());
  }
);

Then(
  "a {actor} may enter {accessLevel} {room} after providing {accessCode}",
  async function (actor, accessLevel, room, accessCode) {
    linkParameters({ room, accessLevel, accessCode });
    await this.driver.manage().deleteAllCookies();

    const roomPage = await this.space
      .visit()
      .then((spacePage) => spacePage.roomCard(room).enter(accessCode));

    assert(!(await roomPage.isWaitingRoom()));
    assert(await roomPage.videoPanel().isDisplayed());
  }
);

Then("the {space} has a {room}", function (space, room) {
  // Write code here that turns the phrase above into concrete actions
  return "pending";
});

Then(
  "the {actor} does not see the {room}'s Door",
  async function (actor, room) {
    const card = new RoomCardComponent(this.driver, room);
    assert(!(await card.isDisplayed()));
  }
);

Then("the Room {accessLevel}", async function (accessLevel) {
  const room = new Room("");
  linkParameters({ room, accessLevel });
  if (accessLevel.level === "Locked") {
    const roomCard = new RoomCardComponent(this.driver, room);
    assert(await roomCard.isLocked());
    assert(await roomCard.enter().then((page) => page.isWaitingRoom()));
  }
});

Then(
  "the {actor} is informed they need to set {accessCode} when they are locking a {room}",
  async function (actor, accessCode, room) {
    const roomSettingPage = new RoomEditPage(this.driver);
    assert(await roomSettingPage.accessCodeError());
  }
);
