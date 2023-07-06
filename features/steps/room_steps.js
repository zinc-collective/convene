import { Given, When, Then } from "@cucumber/cucumber";
import {
  SpacePage,
  SpaceEditPage,
  RoomEditPage,
  RoomPage,
} from "../harness/Pages.js";
import { RoomCardComponent } from "../harness/Components.js";
import {
  Space,
  Room,
  Actor,
  linkParameters,
  AccessLevel,
} from "../lib/index.js";
import assert$0 from "assert";
const assert = assert$0.strict;
Given(
  "{a} {space} with {a} {accessLevel} {room}",
  async function (_, space, _1, accessLevel, room) {
    this.spaces = this.spaces || {};
    if (this.spaces[space.name]) {
      return;
    }
    return this.api()
      .spaces()
      .create(space)
      .then((space) => (this.spaces[space.name] = space));
  },
);

When("the {actor} taps the {room} in the Room Picker", function (actor, room) {
  return this.space.roomCard(room).enter();
});
Then("the {actor} is placed in the {room}", async function (actor, room) {
  const roomPage = new RoomPage(this.driver, room);
  assert(await roomPage.hasContent(room.name));
});
Then("the {actor} is not placed in the {room}", function (actor, room) {
  // Write code here that turns the phrase above into concrete actions
  return "pending";
});

Then("the {space} has a {room}", function (space, room) {
  // Write code here that turns the phrase above into concrete actions
  return "pending";
});
Then(
  "the {actor} does not see the {room}'s Door",
  async function (actor, room) {
    const card = new RoomCardComponent(this.driver, room);
    assert(!(await card.isDisplayed()));
  },
);
Then("{a} {room} is {accessLevel}", async function (_a, room, accessLevel) {
  const { space } = linkParameters({ room, accessLevel });
  await new SpacePage(this.driver, space).visit();
});
