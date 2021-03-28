const slugify = require ('./slugify');
const AccessLevel = require('./AccessLevel')

class Room {

  /**
   * @type {AccessLevel | undefined}
   */
  accessLevel;

  /**
   * @param {string} roomName
   */
  constructor(roomName) {
    this.name = roomName;
    if(roomName !== "Room") {
      this.slug = slugify(roomName);
    }
  }


  reinitialize({ accessLevel }) {
    this.accessLevel = accessLevel
  }
}


module.exports = Room;