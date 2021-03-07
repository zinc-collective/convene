const { defineParameterType } = require("cucumber");

// Actors are the people or sytems our test suite emulates as it
// interacts with Convene.
defineParameterType({
  name: "actor",
  regexp: /(Guest|Space Member|Space Admin)/,
  transformer: (type) => new Actor(type)
});


class Actor {
  constructor(type) {
    this.type = type
    this.email = `${type}@example.com`
  }
}
