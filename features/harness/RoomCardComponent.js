const { By, ThenableWebDriver } = require("selenium-webdriver");

const Component = require("./Component");

const Room = require("../lib/Room");
const AccessCode = require("../lib/AccessCode");

const RoomPage = require("./RoomPage");
const RoomEditPage = require("./RoomEditPage");
const WaitingRoomPage = require("./WaitingRoomPage");

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
   * @returns {Promise<boolean>}
   */
  isLocked() {
    return this.lockedIcon().isDisplayed();
  }

  /**
   * @returns {Component}
   */
  lockedIcon() {
    return this.component(".icon.--lock");
  }

  /**
   * @param {AccessCode | undefined } accessCode
   * @returns {Promise<RoomPage>}
   */
  enter(accessCode) {
    return this.enterRoomButton()
      .click()
      .then(() => this.maybeEnterAccessCode(accessCode, RoomPage));
  }

  /**
   * @param {string | undefined } accessCode
   * @param {RoomPage | WaitingRoomPage} expectedPage
   * @returns {Promise<RoomPage> | Promise<WaitingRoomPage>}
   */
  async maybeEnterAccessCode(accessCode, expectedPage) {
    if (!accessCode) {
      return new expectedPage(this.driver, this.room);
    }
    return new WaitingRoomPage(this.driver, this.room).submitAccessCode(
      accessCode,
      expectedPage
    );
  }

  /**
   * @returns {Component}
   */
  enterRoomButton() {
    return this.component(".room-door_enter");
  }

  /**
   * @param {string | undefined } accessCode
   * @returns {Promise<RoomEditPage>}
   */
  configure(accessCode) {
    return this.configureRoomButton()
      .click()
      .then(() => this.maybeEnterAccessCode(accessCode, RoomEditPage));
  }

  /**
   * @returns {Component}
   */
  configureRoomButton() {
    return this.component(".--configure");
  }
}

module.exports = RoomCardComponent;
