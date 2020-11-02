const Page = require("./Page");
const RoomSettingPage = require("./RoomSettingPage")
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
    this.driver.manage().deleteAllCookies();
    this.enter();
    await this.enterRoom(room);

    const inputSelector = By.css("[id='waiting_room_access_code']");
    await this.driver.wait(until.elementLocated(inputSelector));
    const accessCodeInput = await this.driver.findElement(inputSelector);
    accessCodeInput.sendKeys(accessCode);

    const submitInput = await this.driver.findElement(By.css("[type='submit']"));
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
    return this.driver.findElements(By.css(`.--${accessLevel.level.toLowerCase()}`));
  }

  async enterConfigureRoom(room) {
    const roomCard = await this.findRoomCard(room);
    console.log('roomCard', roomCard)
    const linkText = await roomCard.findElement(By.partialLinkText("Configure Room"));
    await linkText.click();
    return new RoomSettingPage(this.driver, room);
  }
}

module.exports = WorkspacePage;
