const Component = require("./Component");
const Room = require("../lib/Room");

class RoomCardComponent extends Component {
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
    return this
  }
}

module.exports = RoomCardComponent;
