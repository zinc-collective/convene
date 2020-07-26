const { defineParameterType } = require("cucumber");

defineParameterType({
  name: "room",
  regexp: /Room/,
  transformer: (room) => new Room(room)
})

class Room {
  constructor(room) {
    this.room = room
  }
}

// Provides the access level specified in the feature definition to steps
defineParameterType({
  name: "accessLevel",
  regexp: /(Internal|Locked Internal|Locked|Unlocked)/,
  transformer: (level) =>  new AccessLevel(level)
});

class AccessLevel {
  constructor(level) {
    this.level = level
  }
}


// Provides the access level specified in the feature definition to steps
defineParameterType({
  name: "publicityLevel",
  regexp: /(Unlisted|Listed)/,
});

class PublicityLevel {
  constructor(level) {
    this.level = level
  }
}
