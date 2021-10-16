const { webpackConfig, merge } = require("@rails/webpacker");

customConfig = {
  resolve: {
    extensions: [".css"],
  },
};

module.exports = merge(webpackConfig, customConfig);
