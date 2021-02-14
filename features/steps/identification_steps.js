const { Given, When, Then } = require("cucumber");
const SignInPage = require("../page-objects/SignInPage");

Given(
  "a {actor} has Identified themselves using an Email Address",
  function (actor) {
    const signInPage = new SignInPage(this.driver);
    signInPage.submitEmail("email@example.com");
  }
);

Given("an Authenticated Session", function () {
  // Write code here that turns the phrase above into concrete actions
  const signInPage = new SignInPage(this.driver);
  signInPage.submitEmail("email@example.com");
  

});

When(
  "the {actor} opens the Identification Verification Link emailed to them",
  function (actor) {
    // Write code here that turns the phrase above into concrete actions
    return "pending";
  }
);

When("the Authenticated Person Signs Out", function () {
  // Write code here that turns the phrase above into concrete actions
  return "pending";
});

Then(
  "the {actor} is Verified as the Owner of that Email Address",
  function (actor) {
    // Write code here that turns the phrase above into concrete actions
    return "pending";
  }
);

Then("the {actor} has become Authenticated", function (actor) {
  // Write code here that turns the phrase above into concrete actions
  return "pending";
});

Then("the Authenticated Person becomes a {actor}", function (actor) {
  // Write code here that turns the phrase above into concrete actions
  return "pending";
});
