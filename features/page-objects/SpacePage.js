const Page = require("./Page");
const RoomSettingPage = require("./RoomSettingPage")
const { By, until } = require('selenium-webdriver');
const RoomCard = require("./page-elements/RoomCard");
const assert = require('assert').strict;

class SpacePage extends Page {
  constructor(driver, space) {
    super(driver);
    this.space = space;
  }

  async logout() {
    const navToggle = await this.findByCss(".navigation-toggle")
    await navToggle.click()
    const logoutLink = await this.findByCss("#logout")
    await logoutLink.click()
  }

  enter() {
    this.driver.get(`${this.baseUrl}/spaces/${this.space.slug}`);
  }

  enterRoomThruUrl(room) {
    this.driver.get(`${this.baseUrl}/spaces/${this.space.slug}/rooms/${room.slug}`);
  }

  async enterRoom(room) {
    const roomCard = await this.findRoomCard(room);
    await roomCard.findElement(By.linkText("Enter Room")).click();
  }

  async enterRoomWithAccessCode(room, accessCode) {
    this.driver.manage().deleteAllCookies();
    this.enter();
    await this.enterRoom(room);

    const inputSelector = By.css("[id='waiting_room_access_code']");
    await this.driver.wait(until.elementLocated(inputSelector));
    const accessCodeInput = await this.driver.findElement(inputSelector);
    accessCodeInput.sendKeys(accessCode.value);

    const submitInput = await this.driver.findElement(By.css("[type='submit']"));
    await submitInput.click();
  }

  async findRoomCard(room, wait = true) {
    const roomCard = new RoomCard(this.driver, room)
    return roomCard.element(wait)
  }

  async videoPanel() {
    const jitsiConferenceFrame = By.css("[name*='jitsiConferenceFrame']")
    await this.driver.wait(until.elementLocated(jitsiConferenceFrame));
    const videoPanels = await this.driver.findElements(jitsiConferenceFrame);
    assert.equal(videoPanels.length, 1, `${videoPanels.length} was found.`)
    return await this.driver.findElement(jitsiConferenceFrame);
  }

  roomCardsWhere({ accessLevel }) {
    return this.driver.findElements(accessLevel.locator);
  }

  async enterConfigureRoom(room) {
    const roomCard = await this.findRoomCard(room);
    const linkText = await roomCard.findElement(By.linkText("Configure Room"));
    await linkText.click();

    return new RoomSettingPage(this.driver, room);
  }
}

module.exports = SpacePage;
