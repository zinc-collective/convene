const { defineParameterType } = require("cucumber");

// This injects a Space class into steps with named Spaces (i.e.)
// `the "Convene Demo" Space` and steps that mention `Space` in
// isolation.
defineParameterType({
  name: "space",
  regexp: /"([^"]*)" ?Space/,
  transformer: (space) => new Space(space),
});

class Space {
  constructor(spaceName) {
    this.name = spaceName;
    this.slug = spaceName.replace(/\s+/g, '-').toLowerCase();
  }
}

module.exports = Space;
