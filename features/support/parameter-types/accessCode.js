import { defineParameterType } from "@cucumber/cucumber";
import { AccessCode } from "../../lib/index.js";
defineParameterType({
  name: "accessCode",
  regexp: /(correct |valid |wrong |empty )?Access Code/,
  transformer: (validity = "") => new AccessCode(validity.trim()),
});
