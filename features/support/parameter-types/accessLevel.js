const { AccessLevel } = require("../../lib");
const { defineParameterType } = require("@cucumber/cucumber");

// This matches steps based on the access control model
// See: https://github.com/zinc-collective/convene/issues/40
// See: https://github.com/zinc-collective/convene/issues/41
defineParameterType({
  name: "accessLevel",
  regexp: /(Unlocked|Internal|Locked)/,
  transformer: (level) => new AccessLevel(level),
});
