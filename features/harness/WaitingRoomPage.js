import RoomPage from "./RoomPage.js";
class WaitingRoomPage extends RoomPage {
  /**
   * @param {AccessCode} accessCode
   * @returns {Promise<RoomPage> | Promise<WaitingRoomPage> }
   */
  submitAccessCode(accessCode, resultingPage = RoomPage) {
    return this.accessCodeField()
      .fillIn(accessCode.value)
      .then(() => this.submitButton().click())
      .then(() =>
        accessCode.isValid() ? new resultingPage(this.driver, this.room) : this
      )
      .catch(() => this);
  }
  /**
   * @returns {Component}
   */
  submitButton() {
    return this.component("[type='submit']");
  }
  /**
   * @returns {Component}
   */
  accessCodeField() {
    return this.component("#waiting_room_access_code");
  }
  /**
   * @returns {Component}
   */
  errors() {
    return this.component(".field_with_errors");
  }
}
export default WaitingRoomPage;
