const appUrl = require("../lib/appUrl");
const { By, until } = require("selenium-webdriver");

class Page {
  constructor(driver) {
    this.baseUrl = appUrl();
    this.driver = driver;
  }

  async findByCss(cssSelector) {
    const selector = By.css(cssSelector);
    await this.driver.wait(until.elementLocated(selector));
    return this.driver.findElement(selector);
  }
}

module.exports = Page;
