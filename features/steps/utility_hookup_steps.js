import { When, Then } from "@cucumber/cucumber";
import { SpaceEditPage } from "../harness/Pages.js";
import { Actor, Space } from "../lib/index.js";

When("a Space Owner adds a Hookup to their Space", async function () {
  this.actor = new Actor("Space Owner", "space-owner@example.com");
  await this.actor.signIn(this.driver);
  this.space = new Space({ name: "System Test" });
  const page = new SpaceEditPage(this.driver, this.space);
  await page.visit().then((p) => p.addUtilityHookup("stripe"));
});

Then("the Space Owner can configure that Hookup for their Space", function () {
  // Write code here that turns the phrase above into concrete actions
  return "pending";
});

Then("that Hookup can not be used by Furniture in the Space", function () {
  // Write code here that turns the phrase above into concrete actions
  return "pending";
});
