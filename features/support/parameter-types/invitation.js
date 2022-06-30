import { defineParameterType } from "@cucumber/cucumber";
import Invitation from "../../lib/Invitation.js";
defineParameterType({
  name: "invitation",
  regexp: /Invitation( to "[^"]*")?/,
  transformer: function (a, b, c) {
    let emailAddress = this.upsertTestId(
      a ? a.match(/to "([^"]*)"/)[1] : undefined
    );
    return new Invitation(emailAddress);
  },
});
