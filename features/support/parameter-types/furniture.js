
const { defineParameterType } = require("@cucumber/cucumber");
const Furniture = require("../../lib/Furniture");


defineParameterType({
  name: "furniture",
  regexp: /"(.*)" Furniture/,
  transformer: function(type) {
    return new Furniture({ type })
  }
});