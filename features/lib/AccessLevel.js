const { By } = require('selenium-webdriver');
class AccessLevel {
  constructor(level) {
    this.level = level;
  }

  /**
   * @returns {By}
   */
  get locator() {
    return By.css(`.--${this.level.toLowerCase()}`)
  }
}

module.exports = AccessLevel