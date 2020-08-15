const { Given, When, Then } = require("cucumber");
const WorkspacePage = require("../page-objects/WorkspacePage");

Given('the {actor} is on the {workspace} Dashboard', async function (actor, workspace) {
  await new WorkspacePage(this.driver).enter(workspace);
});

Then('the {workspace} is available at the {string} domain', function (workspace, string) {
  // Write code here that turns the phrase above into concrete actions
  return 'pending';
});

Then('there is a {workspace}', function (workspace) {
  // Write code here that turns the phrase above into concrete actions
  return 'pending';
});