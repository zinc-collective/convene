import { Given, When, Then } from "@cucumber/cucumber";
import { RoomPage, SpacePage, SpaceEditPage } from "../harness/Pages.js";
import { linkParameters, Actor, Space } from "../lib/index.js";
import appUrl from "../lib/appUrl.js";
import { Api } from "../lib/Api.js";
import AuthenticationMethod from "../lib/AuthenticationMethod.js";
import Membership from "../lib/Membership.js";
import crypto from "crypto";
Given("{a} {space}", function (_, space) {
  this.spaces = this.spaces || {};
  return this.api()
    .spaces()
    .create(space)
    .then((space) => (this.spaces[space.name] = space));
});
Given("a Space with a Room", function () {
  // This space intentionally left blank... For now...
  // TODO: Create a Space for each test instead of re-using the
  //       System Test Space
});
Given(
  "{a} {space} has {a} {actor}",
  /**
   *
   * @param {*} _
   * @param {Space} space
   * @param {*} _
   * @param {Actor} actor
   * @returns
   */
  function (_a1, space, _a2, actor) {
    this.actors = this.actors || {};
    this.actors[actor.email] = actor;
    space = this.spaces[space.name] || space;
    const api = new Api(appUrl(), process.env.OPERATOR_API_KEY);
    const toCreate = new AuthenticationMethod({
      contactMethod: "email",
      contactLocation: actor.email,
    });
    return api
      .authenticationMethods()
      .findOrCreateBy(toCreate)
      .then((authenticationMethod) =>
        api
          .spaceMemberships()
          .findOrCreateBy(
            new Membership({ space, member: authenticationMethod.person })
          )
      );
  }
);
Given("the {actor} is on the {space} Dashboard", async function (actor, space) {
  this.space = new SpacePage(this.driver, space);
  await this.space.visit();
});
When(
  "{a} {actor} visits {a} {space}",
  /**
   * @this {CustomWorld}
   * @param {*} _a
   * @param {Actor} actor
   * @param {*} _a2
   * @param {Space} space
   * @returns
   */
  function (_a, actor, _a2, space) {
    this.space = new SpacePage(this.driver, space);
    return this.space.visit();
  }
);
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
