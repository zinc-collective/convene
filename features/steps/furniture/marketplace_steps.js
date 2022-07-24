import { Given, When, Then } from "@cucumber/cucumber";
Given('{a} Marketplace Vendor {string} in {a} {space} has:', function (a, string, a2, space, dataTable) {
  // Write code here that turns the phrase above into concrete actions
  return 'pending';
});


Given('{a} Marketplace Vendor {string} offers {a} following Products in {a} {space}', function (a, string, a2, a3, space, dataTable) {
  // Write code here that turns the phrase above into concrete actions
  return 'pending';
});

When('{a} {actor} places {a} Delivery Marketplace Order in {a} {space} for:', function (a, actor, a2, a3, space, dataTable) {
  // Write code here that turns the phrase above into concrete actions
  return 'pending';
});



Then('{a} Marketplace Order placed by {a} {actor} in {a} {space} is delivered to {string}', function (a, a2, actor, a3, space, string) {
  // Write code here that turns the phrase above into concrete actions
  return 'pending';
});

Then('{a} {actor} is charged ${float} for their Marketplace Order', function (a, actor, float) {
  // Write code here that turns the phrase above into concrete actions
  return 'pending';
});

Then('{a} Stripe Account {string} receives {a} Payment of ${float}', function (a, string, a2, float) {
  // Write code here that turns the phrase above into concrete actions
  return 'pending';
});