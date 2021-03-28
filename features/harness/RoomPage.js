const { ThenableWebDriver } = require("selenium-webdriver");
const Component = require("./Component");
const Room = require("../lib/Room");

const Page = require("./Page");

class RoomPage extends Page {
  /**
   * @param {ThenableWebDriver} driver
   * @param {Room} room
   */
  constructor(driver, room) {
    super(driver);
    this.room = room;
  }

  /**
   * @returns {Promise<Boolean>}
   */
  isWaitingRoom() {
    return this.accessCodeForm().isDisplayed();
  }

  /**
   * @returns {Component}
   */
  accessCodeForm() {
    return this.component(".access-code-form");
  }

  videoPanel() {
    return this.component("[name*='jitsiConferenceFrame']");
  }

  path() {
    return `/spaces/${this.room.space.slug}/rooms/${this.room.slug}`;
  }
}

module.exports = RoomPage;
