const { defineParameterType } = require("@cucumber/cucumber");


defineParameterType({
  name: "spotlight",
  regexp: /(\d+) megapixel (\d+x\d+) Spotlight of "([^"]*)"/,
  transformer: function(a,b,c,d) {
    console.log(arguments)
    return { a, b,c, d}
  }
})