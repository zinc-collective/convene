const assert = require("assert").strict;
const { Given, When, Then } = require("cucumber");
const MePage = require("../page-objects/MePage");
const SignInPage = require("../page-objects/SignInPage");
const SpacePage = require("../page-objects/SpacePage");
const Space = require("../parameter-types/spaces");
const MailServer = require("../utilities/MailServer");

Given(
  "an unauthenticated {actor} has requested to be identified via Email",
  function (actor) {
    this.actor = actor;
    const signInPage = new SignInPage(this.driver);
    return signInPage.submitEmail(actor.email);
  }
);

Given("a {actor} Authenticated Session", async function (actor) {
  this.actor = actor;
  const signInPage = new SignInPage(this.driver);
  await signInPage.submitEmail(this.actor.email);

  const mailServer = new MailServer();
  const magicLink = mailServer.getLastAuthenticationLink(this.actor);
  return this.driver.get(magicLink);
});

When(
  "the unauthenticated {actor} opens the Identification Verification Link emailed to them",
  function (actor) {
    const mailServer = new MailServer();
    const magicLink = mailServer.getLastAuthenticationLink(this.actor);
    return this.driver.get(magicLink);
  }
);

When("the Authenticated Person Signs Out", async function () {
  this.space = new SpacePage(this.driver, new Space("System Test"));
  this.space.enter();
  await this.space.logout();
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
  const mePage = new MePage(this.driver);
  await mePage.visit();
  const person = await mePage.person();
  assert.strictEqual(await person.email, `${actor.email}`);
});
