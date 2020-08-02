const { defineParameterType } = require("cucumber");

// This injects a Room class into steps with named rooms (i.e.) `the "Ada" Room` and
// steps that mention `Room` in isolation.
defineParameterType({
  name: "room",
  regexp: /("[^"]*" )?Room/,
  transformer: (room) => new Room(room),
});

class Room {
  constructor(room) {
    this.room = room;
  }
}

// This matches steps based on the access control model
// See: https://github.com/zinc-collective/convene/issues/40
// See: https://github.com/zinc-collective/convene/issues/41
defineParameterType({
  name: "accessLevel",
  regexp: /(Unlocked|Internal|Locked)/,
  transformer: (level) => new AccessLevel(level),
});

class AccessLevel {
  constructor(level) {
    this.level = level;
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
