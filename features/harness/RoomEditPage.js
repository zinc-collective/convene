const Component = require("./Component");
const Page = require("./Page");
const WaitingRoomPage = require("./WaitingRoomPage");
class RoomEditPage extends Page {
  constructor(driver, room) {
    super(driver);
    this.room = room;
  }

  /**
   * @param {AccessCode} accessCode
   * @returns {Promise<this>}
   */
  async lock(accessCode) {
    await this.accessLevel().select("locked");
    await this.accessCode().fillIn(accessCode.value);
    await this.submitButton().click();

    return this;
  }

  /**
   * @param {AccessCode} accessCode
   * @returns {Promise<this>}
   */
  async unlock(accessCode) {
    const waitingRoom = new WaitingRoomPage(this.driver);
    await waitingRoom.submitAccessCode(accessCode);

    await this.accessLevel().select("unlocked");
    await this.submitButton().click();

    return this;
  }

  /**
   * @param {string} accessLevel
   * @returns {Component}
   */
  accessLevel() {
    return this.component("#room_access_level")
  }

  /**
   * @param {AccessCode} accessCode
   * @returns {Component}
   */
  accessCode(accessCode) {
    return this.component("#room_access_code")
  }
  /**
   * @returns {Component}
   */
  submitButton() {
    return this.component("[data-controller='room-form'] [name='commit']")
  }

  /**
   * @returns {Promise<Boolean>}
   */
  accessCodeError() {
    return this.component(
      '.field_with_errors input[name="room[access_code]"]'
    ).isDisplayed();
  }
}

module.exports = RoomEditPage;
