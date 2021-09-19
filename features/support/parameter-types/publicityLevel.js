const { defineParameterType } = require("@cucumber/cucumber");

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