const assert = require("assert").strict;
const getUrls = require("get-urls");
const { Given, When, Then } = require("cucumber");
const MePage = require("../page-objects/MePage");
const SignInPage = require("../page-objects/SignInPage");

Given(
  "a {actor} has Identified themselves using an Email Address",
  function (actor) {
    const signInPage = new SignInPage(this.driver);
    return signInPage.submitEmail("email@example.com");
  }
);

Given("an Authenticated Session", function () {
  const signInPage = new SignInPage(this.driver);
  return signInPage.submitEmail("email@example.com");
});

When(
  "the {actor} opens the Identification Verification Link emailed to them",
  function (actor) {
    return this.maildev.getAllEmail((err, emails) => {
      assert.ok(err == null);
      assert.equal(emails.length, 1);
      const magicLink = getUrls(emails[0].text).values().next().value;
      return this.driver.get(magicLink);
    });
  }
);

When("the Authenticated Person Signs Out", function () {
  // Write code here that turns the phrase above into concrete actions
  return "pending";
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

Then("the Authenticated Person becomes a {actor}", function (actor) {
  // Write code here that turns the phrase above into concrete actions
  return "pending";
});
