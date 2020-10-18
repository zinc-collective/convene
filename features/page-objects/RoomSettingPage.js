const Page = require("./Page");
const { By, until } = require('selenium-webdriver');
const assert = require('assert').strict;

class RoomSettingPage extends Page {
  constructor(driver, room) {
    super(driver);
    this.room = room;
  }

  async lock(accessCode) {
    await this.setAccessLevel('locked');
    await this.setAccessCode(accessCode);
    await this.clickUpdateRoom();
  }

  async setAccessLevel(accessLevel) {
    const selectSelector = By.id('room_access_level');
    await this.driver.wait(until.elementLocated(selectSelector));
    const accessLevelSelect = await this.driver.findElement(selectSelector);
    accessLevelSelect.click();

    const accessLevelSelector = By.css(`[value=${accessLevel}]`);
    await this.driver.wait(until.elementsLocated(accessLevelSelector));
    const accessLevelOption = await this.driver.findElement(accessLevelSelector)
    accessLevelOption.click();
  }

  async setAccessCode(accessCode) {
    const inputSelector = By.css("[id='room_access_code']");
    await this.driver.wait(until.elementLocated(inputSelector));
    const accessCodeInput = await this.driver.findElement(inputSelector);
    accessCodeInput.sendKeys(accessCode);
  }

  async clickUpdateRoom() {
    const submitInput = await this.findByCss("[type='submit']");
    submitInput.click();
  }
}

module.exports = RoomSettingPage;
