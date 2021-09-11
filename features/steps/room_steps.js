const { Given, When, Then } = require("cucumber");

const {
  SpacePage,
  SpaceEditPage,
  RoomEditPage,
  RoomPage,
} = require("../harness/Pages");
const { RoomCardComponent } = require("../harness/Components");
const {
  Space,
  Room,
  Actor,
  linkParameters,
  AccessCode,
  AccessLevel,
} = require("../lib");

const assert = require("assert").strict;

Given("a Space with {accessLevel} {room}", async function (accessLevel, room) {
  let { space } = linkParameters({ accessLevel, room });
  this.space = await new SpacePage(this.driver, space).visit();
  const matchingRooms = await this.space.roomCardsWhere({ accessLevel });
  if (!matchingRooms.length > 0) {
    const spaceMember = new Actor("Space Member");
    const page = await spaceMember
      .signIn(this.driver, space)
      .then(() => new SpaceEditPage(this.driver, space).visit());

    // @todo Sprout an API for editing a Space so we don't need to do it via
    //       the UI
    if (accessLevel.isLocked()) {
      room.reinitialize(new AccessLevel("unlocked"));
      await page
        .roomCard(room)
        .configure()
        .then((page) => page.lock(new AccessCode("valid")));
    } else {
      room.reinitialize(new AccessLevel("locked"));
      await page
        .roomCard(room)
        .configure()
        .then((page) => page.unlock(new AccessCode("valid")));
    }

    return this.space
      .visit()
      .then(() => this.space.roomCardsWhere({ accessLevel }))
      .then((matchingRooms) => assert(matchingRooms.length > 0));
  }
});

Given("a Space with an {publicityLevel} Room", function (publicityLevel) {
  // Write code here that turns the phrase above into concrete actions
  return "pending";
});

When(
  "a {actor} unlocks {accessLevel} {room} with {accessCode}",
  async function (actor, accessLevel, room, accessCode) {
    const { space } = linkParameters({ room, accessLevel });
    await actor.signIn(this.driver, space);

    return new SpaceEditPage(this.driver, space)
      .visit()
      .then((page) => page.roomCard(room).configure())
      .then((page) => page.unlock(accessCode));
  }
);

When(
  "a {actor} locks {accessLevel} {room} with {accessCode}",
  async function (actor, accessLevel, room, accessCode) {
    const { space } = linkParameters({ accessLevel, room });
    await actor.signIn(this.driver, space);

    return new SpaceEditPage(this.driver, space)
      .visit()
      .then((page) => page.roomCard(room).configure())
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

    const isWaitingRoom = await this.space
      .visit()
      .then((spacePage) => spacePage.roomCard(room).enter(accessCode))
      .then((roomPage) => roomPage.isWaitingRoom())

    assert(!isWaitingRoom);
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
  const { space } = linkParameters({ room, accessLevel });
  await new SpacePage(this.driver, space).visit();
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
