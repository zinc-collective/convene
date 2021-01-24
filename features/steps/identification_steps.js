const { Given, When, Then } = require("cucumber");
const SignInPage = require("../page-objects/SignInPage");

Given('a {actor} has Identified themselves using an Email Address', async function (actor) {
    this.signInPage = new SignInPage(this.driver);
    await this.signInPage.enter();
    await this.signInPage.submitEmail("test@example.com");
 });


 When('the {actor} opens the Identification Verification Link emailed to them', function (actor) {
   // Write code here that turns the phrase above into concrete actions
   return 'pending';
 });


 Then('the {actor} is Verified as the Owner of that Email Address', function (actor) {
   // Write code here that turns the phrase above into concrete actions
   return 'pending';
 });



 Then('the {actor} has become Authenticated', function (actor) {
   // Write code here that turns the phrase above into concrete actions
   return 'pending';
 });


