const assert = require("assert").strict;
const { Given, When, Then } = require("@cucumber/cucumber");

const { SignInPage, SpacePage, MePage } = require("../harness/Pages");
const { Space, Actor } = require("../lib");


Given(
  "an unauthenticated {actor} has requested to be identified via Email",
  async function (actor) {
    this.actor = actor;
    const space = new Space({ name: "System Test" });
    const signInPage = await new SignInPage(this.driver, space).visit();
    return signInPage.submitEmail(actor.email);
  }
);

Given("a {actor} Authenticated Session",
/** @param {Actor} actor */
function (actor) {
  this.actor = actor;
  const space = new Space({ name: "System Test" });
  return this.actor.signIn(this.driver, space)
});

When(
  "the unauthenticated {actor} opens the Identification Verification Link emailed to them",
  /** @param {Actor} actor */
  function (actor) {
    return actor.authenticationUrl().then((url) => this.driver.get(url))
  }
);

When('the unauthenticated {actor} provides the Identification Code emailed to them', function (actor) {

  return actor.authenticationCode()
    .then((code) => new SignInPage(this.driver).submitCode(code))
});

When("the Authenticated Person Signs Out", function () {
  return this.actor.signOut(this.driver)
});

Then(
  "the {actor} is Verified as the Owner of that Email Address",
  async function (actor) {
    const mePage = new MePage(this.driver);
    await mePage.visit();
    const person = await mePage.person();
    assert.strictEqual(await person.email, this.actor.email);
  }
);

Then("the {actor} has become Authenticated", async function (actor) {
  const mePage = new MePage(this.driver);
  await mePage.visit();
  const person = await mePage.person();
  assert.ok(await person.id);
});

Then("the Authenticated Person becomes a {actor}", async function (actor) {
  const mePage = await new MePage(this.driver).visit()
  const person = await mePage.person();
  assert.strictEqual(await person.email, `${actor.email}`);
});
