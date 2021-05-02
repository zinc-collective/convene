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
  addUtilityHookup(slug) {
    return this.newUtilityHookupSelect()
      .select(name)
      .then(() => this.newHookupForm().submit())
      .then(() => this);
  }

  /**
   * @returns {Component}
   */
  newUtilityHookupSelect() {
    return this.newUtilityHookupForm().component('select')
  }

  /**
   * @returns {Component}
   */
  newUtilityHookupForm() {
    return this.component(".new-hookup-form");
  }
}

module.exports = SpaceEditPage;
