const { By, until } = require('selenium-webdriver');

class Page {
  constructor(driver) {
    this.baseUrl = process.env.APP_URL ? process.env.APP_URL : 'http://localhost:3000';
    this.driver = driver;
  }

  async findByCss(cssSelector) {
    const selector = By.css(cssSelector);
    await this.driver.wait(until.elementLocated(selector));
    return this.driver.findElement(selector);
  }
}

module.exports = Page;
