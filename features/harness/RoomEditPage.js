import Page from "./Page.js";
class RoomEditPage extends Page {
  constructor(driver, room) {
    super(driver);
    this.room = room;
  }

  /**
   * @param {string} accessLevel
   * @returns {Component}
   */
  accessLevel() {
    return this.component("#room_access_level");
  }

  /**
   * @returns {Component}
   */
  submitButton() {
    return this.component("[data-controller='room-form'] [name='commit']");
  }
}
export default RoomEditPage;
