const { Builder } = require('selenium-webdriver');
const firefox = require('selenium-webdriver/firefox');

let driver;
driver = new Builder()
.forBrowser('firefox')
.setFirefoxOptions(firefoxOption())
.build();
driver.manage().setTimeouts({ implicit: 1000 });
exports.driver = driver;

function firefoxOption() {
  return process.env.HEADLESS ? new firefox.Options().headless() : new firefox.Options()
}
