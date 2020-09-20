const Page = require("./Page");
const { By, until } = require('selenium-webdriver');
const assert = require('assert').strict;

class WorkspacePage extends Page {
  constructor(driver, workspace) {
    super(driver);
    this.workspace = workspace;
  }

  enter() {
    this.driver.get(`${this.baseUrl}/workspaces/${this.workspace.slug}`);
  }

  enterRoomThruUrl(room) {
    this.driver.get(`${this.baseUrl}/workspaces/${this.workspace.slug}/rooms/${room.slug}`);
  }

  async enterRoom(room) {
    const roomCard = await this.findRoomCard(room);
    roomCard.findElement(By.linkText("Enter Room")).click();
  }

  async enterRoomWithAccessCode(room, accessCode) {
    await this.enterRoom(room);

    const placeholderSelector = By.css("[placeholder='Access Code']");
    await this.driver.wait(until.elementLocated(placeholderSelector));
    const accessCodeInput = await this.driver.findElement(placeholderSelector);
    accessCodeInput.sendKeys(accessCode);

    const submitInput = await this.driver.findElement(By.css("[value='Submit']"));
    submitInput.click();
  }

  async findRoomCard(room, wait = true) {
    if(wait) {
      await this.driver.wait(until.elementLocated(By.id(room.name)));
    }

    return await this.driver.findElement(By.id(room.name));
  }

  async videoPanel() {
    const jitsiConferenceFrame = By.css("[name*='jitsiConferenceFrame']")
    await this.driver.wait(until.elementLocated(jitsiConferenceFrame));
    const videoPanels = await this.driver.findElements(jitsiConferenceFrame);
    assert.equal(videoPanels.length, 1, `${videoPanels.length} was found.`)
    return await this.driver.findElement(jitsiConferenceFrame);
  }

  roomCardsWhere({ accessLevel }) {
    const selector = `.--${accessLevel.level.toLowerCase()}`
    return this.driver.findElements(By.css(`.--${accessLevel.level.toLowerCase()}`));
  }
}

module.exports = WorkspacePage;
