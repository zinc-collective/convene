const { defineParameterType } = require("@cucumber/cucumber");


defineParameterType({
  name: "spotlight",
  regexp: /(\d+) megapixel (\d+x\d+) Spotlight of "([^"]*)"/,
  transformer: function(megapixel, aspectRatio, fileName ) {
    console.log(arguments)
    return { megapixel, aspectRatio, fileName }
  }
})