const { setWorldConstructor, After, setDefaultTimeout } = require('cucumber');
const { Builder } = require('selenium-webdriver');
const firefox = require('selenium-webdriver/firefox');

class CustomWorld {
  constructor() {
    this.driver = new Builder()
      .forBrowser('firefox')
      .setFirefoxOptions(
        new firefox.Options().headless()
      ).build();
  }
}

setWorldConstructor(CustomWorld);

After(function() {
  this.driver.quit();
});

setDefaultTimeout(10 * 1000);
