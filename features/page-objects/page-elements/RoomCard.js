const { By } = require('selenium-webdriver');

const Page = require("../Page");
const RoomPage = require("../RoomPage");

class RoomCard extends Page {
  constructor(driver, webElement) {
    super(driver);
    this.webElement = webElement;
  }

  async isLocked() {
    const lockLogo = await this.webElement.findElement(By.className('fa-lock'));
    lockLogo.isDisplayed();
  }

  async enterRoom() {
    await this.webElement.findElement(By.linkText("Enter Room")).click();
    return new RoomPage(this.driver);
  }
}

module.exports = RoomCard;
