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
  constructor({ name, slug, id}) {
    this.name = name;
    this.slug = slug || slugify(name);
    this.id = id
  }

  reinitialize({ accessLevel }) {
    this.accessLevel = accessLevel
  }

  assign(attributes) {
    for(const attribute in attributes) {
      this[attribute] = attributes[attribute];
    }
    return this
  }
  asParams() {
    return {
    room: { name: this.name, slug: this.slug, furniturePlacementsAttributes: this.furniturePlacementsAttributes }
    }
  }

}


module.exports = Room;