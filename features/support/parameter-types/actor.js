import { defineParameterType } from "@cucumber/cucumber";
import Actor from "../../lib/Actor.js";
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
  transformer: function (actorType, email) {
    email = formatEmail(actorType, email);
    if (email !== "guest@example.com") {
      email = this.upsertTestId(email);
    }
    return new Actor(actorType, email);
  },
});
/**
 * Infers the email from the actorType if necessary; then removes the string matching regex slop.
 * @param {String} actorType
 * @param {undefined|String} email
 * @returns {String} the email
 */
function formatEmail(actorType, email = undefined) {
  email = email || `${actorType.toLowerCase()}@example.com`;
  return email.trim().replace(/\s/, "-").replace(/"/g, "");
}
