import Page from "./Page.js";
class RoomPage extends Page {
  /**
   * @param {ThenableWebDriver} driver
   * @param {Room} room
   */
  constructor(driver, room) {
    super(driver);
    this.room = room;
  }

  path() {
    return `/spaces/${this.room.space.slug}/rooms/${this.room.slug}`;
  }
}
export default RoomPage;
