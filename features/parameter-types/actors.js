const { defineParameterType } = require("cucumber");

// Actors are the people or sytems our test suite emulates as it
// interacts with Convene.
defineParameterType({
  name: "actor",
  regexp: /(Guest|Workspace Member|Workspace Admin)/,
  transformer: (type) => new Actor(type)
});


class Actor {
  constructor(type) {
    this.type = type
  }
}