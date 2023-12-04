import { ThenableWebDriver } from "selenium-webdriver";
import Page from "./Page.js";
import Component from "./Component.js";
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

  createRoom({ room }) {
    return new RoomFormComponent(this.driver)
      .fillIn(room)
      .then((c) => c.submit());
  }

  /**
   * @param {string} slug
   * @returns {Promise<this>}
   */
  addUtility(slug) {
    return this.newUtilitySelect()
      .select(name)
      .then(() => this.newUtilityForm().submit())
      .then(() => this);
  }

  /**
   * @returns {Component}
   */
  newUtilitySelect() {
    return this.newUtilityForm().component("select");
  }

  /**
   * @returns {Component}
   */
  newUtilityForm() {
    return this.component(".new-utility-form");
  }
}
export default SpaceEditPage;
