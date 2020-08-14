const { Given, When, Then } = require("cucumber");

Given('I am on a {workspace} Dashboard', async function (workspace) {
  await this.driver.get(`http://localhost:3000/workspaces/${workspace.slug}`);
});

Then('the {workspace} is available at the {string} domain', function (workspace, string) {
  // Write code here that turns the phrase above into concrete actions
  return 'pending';
});

Then('there is a {workspace}', function (workspace) {
  // Write code here that turns the phrase above into concrete actions
  return 'pending';
});