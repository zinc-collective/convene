const { defineParameterType } = require("@cucumber/cucumber");
const Actor = require('../../lib/Actor.js')

// Actors are the people or sytems our test suite emulates as it
// interacts with Convene.
// We have several Actor types:
// - Guest (Someone who is not authenticated within Convene)
// - Neighbor (Someone who is authenticated within Convene, but not a Member of the Space)
// - Space Member (Someone who is authenticated and is a Member of the Space)
// - Space Owner (Someone who is authenticated and has moderator rights within the Space)
defineParameterType({
  name: "actor",
  regexp: /(Guest|Space Member|Space Owner|Neighbor)( "[^"]*")?/,
  transformer: function(type, email) {
    email = email || `${type.toLowerCase()}@example.com`

    return new Actor(type, email.trim().replace(/\s/, '-').replace(/"/g,''))
  }
});