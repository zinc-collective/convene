import { By } from "selenium-webdriver";
import Component from "./Component.js";
import Room from "../lib/Room.js";
import RoomPage from "./RoomPage.js";
import RoomEditPage from "./RoomEditPage.js";
class RoomCardComponent extends Component {
  /**
   * @param {ThenableWebDriver} driver
   * @param {Room} room
   */
  constructor(driver, room = new Room({ name: "" })) {
    super(driver);
    // TODO: Try to build a room from the passed in Element if undefined
    this.room = room;
  }
  get selector() {
    if (this._selector && this._selector.value) {
      return this._selector;
    }
    const selectorParts = ["*[data-model='room']"];
    if (this.room.slug) {
      selectorParts.push(`[data-slug="${this.room.slug}"]`);
    }
    if (this.room.accessLevel) {
      selectorParts.push(this.room.accessLevel.attributeSelector);
    }
    return (this.selector = By.css(selectorParts.join("")));
  }
  set selector(value) {
    this._selector = value;
  }

  /**
   * @returns {Promise<RoomPage>}
   */
  enter() {
    return this.enterRoomButton().click();
  }

  /**
   * @returns {Component}
   */
  enterRoomButton() {
    return this.component("*[data-role=enter]");
  }
  /**
   * @returns {Promise<RoomEditPage>}
   */
  configure() {
    return this.configureRoomButton().click();
  }
  /**
   * @returns {Component}
   */
  configureRoomButton() {
    return this.component(".--configure");
  }
}
export default RoomCardComponent;
