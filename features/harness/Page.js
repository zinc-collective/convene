const appUrl = require("../lib/appUrl");
const { ThenableWebDriver, By } = require("selenium-webdriver");
const Component = require("./Component");
const PersonNavigationComponent = require("./PersonNavigationComponent");

class Page {
  /**
   * @param {ThenableWebDriver} driver
   */
  constructor(driver) {
    this.baseUrl = appUrl();
    this.driver = driver;
  }

  /**
   * Factory for building {Component}s
   * @param {string} selector
   * @param {class} componentClass
   * @returns {Component}
   */
  component(selector, componentClass = Component) {
    return new componentClass(this.driver, selector);
  }

  /**
   * @returns {PersonNavigationComponent}
   */
  personNavigation() {
    return this.component(".profile-menu", PersonNavigationComponent);
  }

  /**
   * Goes directly to the page, as defined in the path method.
   * @returns {Promise<this>}
   */
  visit() {
    return this.driver.get(`${this.baseUrl}${this.path()}`).then(() => this);
  }

  /**
   * @param {RegExp} content
   * @returns {Promise<Boolean>}
   */
  hasContent(content) {
    return this.driver.findElement(By.tagName('body')).getText().then(
      (body) =>
        (body.match(content))
    )
  }

  /**
   * @throws if not defined in child classes
   */
  path() {
    throw "NotImplemented";
  }
}

module.exports = Page;
