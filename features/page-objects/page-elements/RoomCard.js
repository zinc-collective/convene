const { By, until } = require('selenium-webdriver');

const Page = require("../Page");
const RoomPage = require("../RoomPage");

class RoomCard extends Page {
  constructor(driver, room) {
    super(driver);
    this.room = room
  }

  async element(wait=true) {
    if(wait) {
      await this.driver.wait(until.elementLocated(this.room.cardLocator));
    }
    return this.driver.findElement(this.room.cardLocator);
  }

  async isLocked() {
    const lockLogo = (await this.element()).findElement(By.className('fa-lock'));
    return lockLogo.isDisplayed();
  }

  async enterRoom() {
    (await this.element()).findElement(By.linkText("Enter Room")).click();
    return new RoomPage(this.driver);
  }
}

module.exports = RoomCard;
