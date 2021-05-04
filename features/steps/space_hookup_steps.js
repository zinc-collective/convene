const { Given, When, Then } = require("cucumber");

const { SpaceEditPage } = require("../harness/Pages");
const { Actor, Space } = require("../lib");


When("a Space Owner adds a Hookup to their Space", async function () {
  this.actor = new Actor("Space Owner");
  await this.actor.signIn(this.driver);
  this.space = new Space("System Test");

  const page = new SpaceEditPage(this.driver, this.space);
  await page.visit().then((p) => p.addHookup("Jitsi Meet"));
});

Then("the Space Owner can configure that Hookup for their Space", function () {
  // Write code here that turns the phrase above into concrete actions
  return "pending";
});

Then("that Hookup can not be used by Furniture in the Space", function () {
  // Write code here that turns the phrase above into concrete actions
  return "pending";
});
