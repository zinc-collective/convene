const { defineParameterType } = require("@cucumber/cucumber");
const Space = require("../../lib/Space");

// This injects a Space class into steps with named Spaces (i.e.)
// `the "Convene Demo" Space` and steps that mention `Space` in
// isolation.
defineParameterType({
  name: "space",
  regexp: /("[^"]*" )?Space/,
  transformer: function (name = "System Test") {
    const tidyName = name.trim().replace(/\"/g, "");
    this.spaces = this.spaces || {};
    return (this.spaces[tidyName] =
      this.spaces[tidyName] ||
      new Space({ name: `${this.testId()} ${tidyName}` }));
  },
});
