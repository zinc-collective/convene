const { setWorldConstructor, After } = require('cucumber');
const { Builder } = require('selenium-webdriver');

class CustomWorld {
  constructor() {
    this.driver = new Builder().forBrowser('firefox').build();
  }
}

setWorldConstructor(CustomWorld);

After(function() {
  this.driver.quit();
});
