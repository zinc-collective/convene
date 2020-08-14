const { Given, When, Then } = require("cucumber");
const { By, Key, until } = require('selenium-webdriver');

Given('I am on a {workspace} Dashboard', function (workspace) {
  this.driver.get('http://localhost:3000/workspaces/system-test');
});

// TODO: Move to room_step.js, putting these here for easier init setup
When('I tap the {room} in the {room} Picker', async function (room, room2) {
  const roomCard = this.driver.findElement(By.partialLinkText('Enter Room'))
  await roomCard.click()
});

Then('I am in the {room}', function (room) {
  // expect jitsi iframe exist
});





Then('the {workspace} is available at the {string} domain', function (workspace, string) {
  // Write code here that turns the phrase above into concrete actions
  return 'pending';
});

Then('there is a {workspace}', function (workspace) {
  // Write code here that turns the phrase above into concrete actions
  return 'pending';
});