import { Given, Then } from "@cucumber/cucumber";
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

Then("the {space} has a {room}", function (space, room) {
  // Write code here that turns the phrase above into concrete actions
  return "pending";
});
