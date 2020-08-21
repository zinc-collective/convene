const { setWorldConstructor, After, setDefaultTimeout } = require('cucumber');
const { Builder, logging } = require('selenium-webdriver');

class CustomWorld {
  constructor() {
    this.driver = new Builder().forBrowser('firefox').build();
  }
}

setWorldConstructor(CustomWorld);

After(function() {
  this.driver.quit();
});

setDefaultTimeout(10 * 1000);

new logging.Preferences().setLevel(logging.Type.BROWSER, logging.Level.DEBUG);
