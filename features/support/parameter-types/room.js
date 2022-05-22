const { defineParameterType } = require("@cucumber/cucumber");
const { Room } = require("../../lib");

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
  transformer: (roomName = "") => new Room({ name: roomName.trim().replace(/"/g, "") }),
});


defineParameterType({
  name: "entranceHall",
  regexp: /Entrance Hall/,
  transformer: () => new Room({ name: "Entrance Hall" })
})