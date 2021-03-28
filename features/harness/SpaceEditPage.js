const { ThenableWebDriver } = require("selenium-webdriver");
const Page = require('./Page');
const Component = require("./Component");

class SpaceEditPage extends Page {
  /**
   * @param {ThenableWebDriver} driver
   * @param {Space} space
   */
  constructor(driver, space) {
    super(driver);
    this.space = space;
  }

  /**
   * @returns {string}
   */
  path() {
    return `/spaces/${this.space.slug}/edit`;
  }

  /**
   * @param {string} slug
   * @returns Promise<SpaceEditPage>
   */
  addHookup(slug) {
    return this.newHookupSelect()
      .select(name)
      .then(() => this.newHookupForm().submit())
      .then(() => this);
  }

  /**
   * @returns {Component}
   */
  newHookupSelect() {
    return this.newHookupForm().component('select')
  }

  /**
   * @returns {Component}
   */
  newHookupForm() {
    return this.component(".new-hookup-form");
  }
}

module.exports = SpaceEditPage;
