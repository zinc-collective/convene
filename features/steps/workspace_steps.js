const { Given, When, Then } = require("cucumber");

Given('the {actor} is on the {workspace} Dashboard', async function (actor, workspace) {
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