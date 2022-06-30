import { defineParameterType } from "@cucumber/cucumber";
defineParameterType({
  name: "a",
  regexp: /(a|an|the)/,
});
