const assert = require("assert").strict;
const getUrls = require("get-urls");
const { Given, When, Then } = require("cucumber");
const MePage = require("../page-objects/MePage");
const SignInPage = require("../page-objects/SignInPage");
const SpacePage = require("../page-objects/SpacePage");
const Space = require("../parameter-types/spaces");
const MailServer = require("../utilities/MailServer");

Given(
  "a {actor} has Identified themselves using an Email Address",
  function (actor) {
    const signInPage = new SignInPage(this.driver);
    return signInPage.submitEmail("email@example.com");
  }
);

Given("an Authenticated Session", function () {
  const signInPage = new SignInPage(this.driver);
  signInPage.submitEmail("email@example.com");
  const mailServer = new MailServer;
  return mailServer.getAllEmails().then((emails) => {
    assert.equal(emails.length, 1);
    const magicLink = getUrls(emails[0].text).values().next().value;
    return this.driver.get(magicLink);
  });
});

When(
  "the {actor} opens the Identification Verification Link emailed to them",
  function (actor) {
    const mailServer = new MailServer;
    return mailServer.getAllEmails().then((emails) => {
      assert.equal(emails.length, 1);
      const magicLink = getUrls(emails[0].text).values().next().value;
      return this.driver.get(magicLink);
    });
  }
);

When("the Authenticated Person Signs Out", async function () {
  this.space = new SpacePage(this.driver, new Space("System Test"));
  this.space.enter()
  await this.space.logout()
});

Then(
  "the {actor} is Verified as the Owner of that Email Address",
  async function (actor) {
    const mePage = new MePage(this.driver);
    await mePage.visit();
    assert.strictEqual(await mePage.email(), "email@example.com");
  }
);

Then("the {actor} has become Authenticated", async function (actor) {
  const mePage = new MePage(this.driver);
  await mePage.visit();
  assert.ok(await mePage.id());
});

Then("the Authenticated Person becomes a {actor}", async function (actor) {
  const mePage = new MePage(this.driver);
  await mePage.visit();
  assert.strictEqual(await mePage.email(), `${actor.email}`);
});
