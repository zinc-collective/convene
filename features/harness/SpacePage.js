import Page from "./Page.js";
class SpacePage extends Page {
  constructor(driver, space) {
    super(driver);
    this.space = space;
  }
  /**
   * @returns {string}
   */
  path() {
    return `/spaces/${this.space.slug}`;
  }
}
export default SpacePage;
