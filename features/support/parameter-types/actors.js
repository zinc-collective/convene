const { defineParameterType } = require("cucumber");
const Actor = require('../../lib/Actor.js')

// Actors are the people or sytems our test suite emulates as it
// interacts with Convene.
defineParameterType({
  name: "actor",
  regexp: /(Guest|Space Member|Space Admin)/,
  transformer: (type) => new Actor(type)
});