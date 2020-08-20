const Page = require("./Page");
const { By, until } = require('selenium-webdriver');
const assert = require('assert').strict;

class WorkspacePage extends Page {
  constructor(driver) {
    super(driver);
  }

  enter(workspace) {
    this.driver.get(`${this.baseUrl}/workspaces/${workspace.slug}`);
  }

  enterRoomThruUrl(workspace, room) {
    this.driver.get(`${this.baseUrl}/workspaces/${workspace.slug}/rooms/${room.slug}`);
  }

  async enterRoom(room) {
    const roomCard = await this.findRoomCard(room);
    roomCard.findElement(By.linkText("Enter Room")).click();
  }

  async findRoomCard(room) {
    await this.driver.wait(until.elementLocated(By.id(room.name)));
    return await this.driver.findElement(By.id(room.name));
  }

  async videoPanel() {
    const jitsiConferenceFrame = By.css("[name*='jitsiConferenceFrame']")
    await this.driver.wait(until.elementLocated(jitsiConferenceFrame));
    const videoPanels = await this.driver.findElements(jitsiConferenceFrame);
    assert.equal(videoPanels.length, 1, `${videoPanels.length} was found.`)
    return await this.driver.findElement(jitsiConferenceFrame);
  }
}

module.exports = WorkspacePage;
