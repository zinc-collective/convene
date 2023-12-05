import Component from "./Component.js";
import Room from "../lib/Room.js";
class RoomFormComponent extends Component {
  /**
   * @param {ThenableWebDriver} driver
   * @param {Room} room
   */
  constructor(driver, room = new Room("")) {
    super(driver);
    // TODO: Try to build a room from the passed in Element if undefined
    this.room = room;
  }
  /**
   * @param {Room} room
   * @returns {Promise<this>}
   */
  async fillIn(room) {
    return this;
  }
}
export default RoomFormComponent;
