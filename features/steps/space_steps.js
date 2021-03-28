const { Given, When, Then } = require("cucumber");
const { RoomPage, SpacePage } = require("../harness/Pages");

Given('the {actor} is on the {space} Dashboard', async function (actor, space) {
  this.space = new SpacePage(this.driver, space);
  await this.space.visit();
});

Given('the {actor} is in the {space} and in the {room}', function (actor, space, room) {
  this.space = new SpacePage(this.driver, space);
  return this.space.visit()
                   .then((spacePage) => spacePage.roomCard(room).enter())
});

When('the {actor} visit the {space}, {room} full URL', function (actor, space, room) {
  this.space = new SpacePage(this.driver, space)
  room.space = space
  return new RoomPage(this.driver, room).visit()
});

Then('the {space} is available at the {string} domain', function (space, string) {
  // Write code here that turns the phrase above into concrete actions
  return 'pending';
});

Then('there is a {space}', function (space) {
  // Write code here that turns the phrase above into concrete actions
  return 'pending';
});
