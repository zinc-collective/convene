import { ThenableWebDriver } from "selenium-webdriver";
import Page from "./Page.js";

class MembershipsIndexPage extends Page {
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
    return `/spaces/${this.space.slug}/memberships`;
  }
}
export default MembershipsIndexPage;
