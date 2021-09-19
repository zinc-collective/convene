const { defineParameterType } = require("@cucumber/cucumber");

defineParameterType({
  name: "a",
  regexp: /(a|an|the)/,
});
