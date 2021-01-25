const { Given, When, Then } = require("cucumber");
const SpacePage = require("../page-objects/SpacePage");

Given('the {actor} is on the {space} Dashboard', async function (actor, space) {
  this.space = new SpacePage(this.driver, space);
  await this.space.enter();
});

Given('the {actor} is in the {space} and in the {room}', async function (actor, space, room) {
  this.space = new SpacePage(this.driver, space);
  await this.space.enter();
  await this.space.enterRoom(room);
});

When('the {actor} visit the {space}, {room} full URL', async function (actor, space, room) {
  this.space = new SpacePage(this.driver, space);
  await this.space.enterRoomThruUrl(room);
});

Then('the {space} is available at the {string} domain', function (space, string) {
  // Write code here that turns the phrase above into concrete actions
  return 'pending';
});

Then('there is a {space}', function (space) {
  // Write code here that turns the phrase above into concrete actions
  return 'pending';
});
