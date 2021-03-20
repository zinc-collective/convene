const { defineParameterType } = require("cucumber");
const { By } = require('selenium-webdriver');
const concatRegExp = require('../lib/concatRegExp');
const FLEXIBLE_ARTICLE_ADJECTIVES = /(an |the |is |a )/;

// This injects a Room class into steps with named rooms (i.e.) `the "Ada" Room` and
// steps that mention `Room` in isolation.
defineParameterType({
  name: "room",
  // To make the Room Name optional, we had to capture two things, otherwise
  // Cucumber will discard the "room" value. This appears to be because the
  // `Group` class assumes that if there are capture-groups in a parameterType,
  // the rest of the match should be discarded.
  // See: https://github.com/cucumber/cucumber/blob/5a3a3167958c45d708228d953a1d5b0f5625a633/cucumber-expressions/javascript/src/Group.ts#L11
  //
  // There are probably multiple ways to work around this. For example, instead of
  // adding a capture group, we could check if roomName is undefined in the Room
  // class, and default it to 'Room' or something.
  //
  // In the meantime, adding a capture-group around "Room" ensures that the Room
  // class has a string provided to it.
  regexp: /("[^"]*" )?(Room)/,
  transformer: (roomName) => new Room(roomName.trim().replace(/"/g, "")),
});

const slugify = (str) => str.replace(/\s+/g, "-").toLowerCase();
class Room {
  constructor(roomName) {
    this.name = roomName;
    this.slug = slugify(roomName);
  }

  reinitialize({ accessLevel }) {
    this.accessLevel = accessLevel
  }

  get cardLocator() {
    if(this.accessLevel) {
      return this.accessLevel.locator
    }
    return By.id(this.name)
  }
}

// This matches steps based on the access control model
// See: https://github.com/zinc-collective/convene/issues/40
// See: https://github.com/zinc-collective/convene/issues/41
defineParameterType({
  name: "accessLevel",
  regexp: concatRegExp(FLEXIBLE_ARTICLE_ADJECTIVES, /(Unlocked|Internal|Locked)/),
  transformer: (_, level) => new AccessLevel(level),
});

class AccessLevel {
  constructor(level) {
    this.level = level;
  }

  get locator() {
    return By.css(`.--${this.level.toLowerCase()}`)
  }
}

// Defines whether a Room may be discovered or not.
// See: https://github.com/zinc-collective/convene/issues/39
defineParameterType({
  name: "publicityLevel",
  regexp: /(Unlisted|Listed)/,
});

class PublicityLevel {
  constructor(level) {
    this.level = level;
  }
}

defineParameterType({
  name: "accessCode",
  regexp: concatRegExp(FLEXIBLE_ARTICLE_ADJECTIVES, /(correct |valid |wrong |empty )?Access Code/),
  transformer: (_, validity="") => new AccessCode(validity.trim())
});

class AccessCode {
  constructor(validity) {
    this.validity = validity
  }

  get value() {
    if(this.validity == "correct" || this.validity == "valid") {
      return "secret"
    } else if (this.validity == "empty") {
      return ""
    } else {
      return "wrong"
    }
  }
}

module.exports = Room;