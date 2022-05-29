const { defineParameterType } = require("@cucumber/cucumber");


defineParameterType({
  name: "device",
  regexp: /(Portrait|Landscape) (Phone|Tablet)/,
  transformer: function(orientation, device) {
    return { orientation, device }
  }
})