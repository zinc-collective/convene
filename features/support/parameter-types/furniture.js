import { defineParameterType } from "@cucumber/cucumber";
import Furniture from "../../lib/Furniture.js";
defineParameterType({
  name: "furniture",
  regexp: /"(.*)" Furniture/,
  transformer: function (type) {
    return new Furniture({ type });
  },
});
