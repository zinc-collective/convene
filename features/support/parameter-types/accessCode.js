const { defineParameterType } = require("@cucumber/cucumber");
const { AccessCode } = require("../../lib");

defineParameterType({
  name: "accessCode",
  regexp:/(correct |valid |wrong |empty )?Access Code/,
  transformer: (validity = "") => new AccessCode(validity.trim()),
});
