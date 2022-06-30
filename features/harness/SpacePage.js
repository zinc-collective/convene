import assert$0 from "assert";
import Page from "./Page.js";
import RoomCardComponent from "./RoomCardComponent.js";
const assert = assert$0.strict;
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
  /**
   * @param {Room} room
   * @returns {RoomCardComponent}
   */
  roomCard(room) {
    return new RoomCardComponent(this.driver, room);
  }
  /**
   *
   * @param {*} filters
   * @returns {Promise<RoomCardComponent[]}
   */
  roomCardsWhere(filters) {
    const { accessLevel } = filters;
    return this.driver
      .findElements(accessLevel.locator)
      .then((elements) => elements.map((e) => new RoomCardComponent(e)));
  }
}
export default SpacePage;
