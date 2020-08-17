const { Given, When, Then } = require("cucumber");
const WorkspacePage = require("../page-objects/WorkspacePage");

Given('the {actor} is on the {workspace} Dashboard', async function (actor, workspace) {
  this.workspace = new WorkspacePage(this.driver);
  await this.workspace.enter(workspace);
});

Given('the {actor} is in the {workspace} and in the {room}', async function (actor, workspace, room) {
  this.workspace = new WorkspacePage(this.driver);
  await this.workspace.enter(workspace);
  await this.workspace.enterRoom(room);
});

When('the {actor} visit the {workspace}, {room} full URL', async function (actor, workspace, room) {
  this.workspace = new WorkspacePage(this.driver);
  await this.workspace.enterRoomThruUrl(workspace, room);
});

Then('the {workspace} is available at the {string} domain', function (workspace, string) {
  // Write code here that turns the phrase above into concrete actions
  return 'pending';
});

Then('there is a {workspace}', function (workspace) {
  // Write code here that turns the phrase above into concrete actions
  return 'pending';
});