import slugify from "./slugify.js";
import AccessLevel from "./AccessLevel.js";
import Model from "./Model.js";
class Room extends Model {
  /**
   * @type {AccessLevel | undefined}
   */
  accessLevel;
  /**
   * @param {string} roomName
   */
  constructor({ name, slug, id }) {
    super();
    this.name = name;
    this.slug = slug;
    if (name !== "Room") {
      this.slug = this.slug = slugify(name);
    }
    this.id = id;
  }
  reinitialize({ accessLevel }) {
    this.accessLevel = accessLevel;
  }
  asParams() {
    return {
      room: {
        name: this.name,
        slug: this.slug,
        furniturePlacementsAttributes: this.furniturePlacementsAttributes,
      },
    };
  }
}
export default Room;
