const { Given, When, Then } = require("@cucumber/cucumber");
const { RoomPage, SpacePage, SpaceEditPage } = require("../harness/Pages");
const { linkParameters } = require("../lib");
const appUrl = require("../lib/appUrl");
const { Api } = require("../lib/Api");

Given("{a} {space}", function (_, space) {
  const api = new Api(appUrl(), process.env.OPERATOR_API_KEY);

  return api.spaces().create(space);
});

Given("{a} {space} has {a} {actor}", function (_, space, _, actor) {
  return true;
});

Given("the {actor} is on the {space} Dashboard", async function (actor, space) {
  this.space = new SpacePage(this.driver, space);
  await this.space.visit();
});

Given(
  "the {actor} is in the {space} and in the {room}",
  function (actor, space, room) {
    this.space = new SpacePage(this.driver, space);
    return this.space
      .visit()
      .then((spacePage) => spacePage.roomCard(room).enter());
  }
);

When("a {actor} adds a {room}", function (actor, room) {
  const { space } = linkParameters({ actor, room });
  const page = new SpaceEditPage(this.driver, space);
  return page.visit().then((p) => p.createRoom({ room }));
});

When(
  "the {actor} visit the {space}, {room} full URL",
  function (actor, space, room) {
    this.space = new SpacePage(this.driver, space);
    room.space = space;
    return new RoomPage(this.driver, room).visit();
  }
);

Then(
  "the {space} is available at the {string} domain",
  function (space, string) {
    // Write code here that turns the phrase above into concrete actions
    return "pending";
  }
);

Then("there is a {space}", function (space) {
  // Write code here that turns the phrase above into concrete actions
  return "pending";
});
