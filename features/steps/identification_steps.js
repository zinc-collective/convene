import assert$0 from "assert";
import { Given, When, Then } from "@cucumber/cucumber";
import { SignInPage, MePage } from "../harness/Pages.js";
import { Actor } from "../lib/index.js";
const assert = assert$0.strict;
Given(
  "an unauthenticated {actor} has requested to be identified to {a} {space} via Email",
  async function (actor, _a, space) {
    this.actor = actor;
    const signInPage = await new SignInPage(this.driver, space).visit();
    return signInPage.submitEmail(actor.email);
  },
);
Given(
  "{a} {actor} is signed in to {a} {space}",
  function (_a, actor, _a2, space) {
    return actor
      .signOut(this.driver)
      .then(() => actor.signIn(this.driver, space));
  },
);
Given(
  "a {actor} Authenticated Session on {a} {space}",
  /** @param {Actor} actor */
  function (actor, _a, space) {
    this.actor = actor;
    return this.actor.signIn(this.driver, space);
  },
);
When(
  "the unauthenticated {actor} opens the Identification Verification Link emailed to them",
  /** @param {Actor} actor */
  function (actor) {
    return actor.authenticationUrl().then((url) => this.driver.get(url));
  },
);
When(
  "the unauthenticated {actor} provides the Identification Code emailed to them",
  function (actor) {
    return actor
      .authenticationCode()
      .then((code) => new SignInPage(this.driver).submitCode(code));
  },
);
When("the Authenticated Person Signs Out", function () {
  return this.actor.signOut(this.driver);
});
Then(
  "the {actor} is Verified as the Owner of that Email Address",
  async function (actor) {
    const mePage = new MePage(this.driver);
    await mePage.visit();
    const person = await mePage.person();
    assert.strictEqual(await person.email, this.actor.email);
  },
);
Then("the {actor} has become Authenticated", async function (actor) {
  const mePage = new MePage(this.driver);
  await mePage.visit();
  const person = await mePage.person();
  assert.ok(await person.id);
});
Then("the Authenticated Person becomes a {actor}", async function (actor) {
  const mePage = await new MePage(this.driver).visit();
  const person = await mePage.person();
  assert.strictEqual(await person.email, `${actor.email}`);
});
