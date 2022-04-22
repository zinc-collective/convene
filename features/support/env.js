require('dotenv').config()
const crypto = require("crypto");
const fse = require('fs-extra');
const { setWorldConstructor, BeforeAll, AfterAll, After, setDefaultTimeout, Status } = require('@cucumber/cucumber');

const appUrl = require('../lib/appUrl')
const { Builder } = require('selenium-webdriver');
const firefox = require('selenium-webdriver/firefox');


let driver;


class CustomWorld {
  constructor() {
    this.driver = driver;
  }

  testId() {
    return this._testId = this._testId || crypto.randomUUID();
  }
}

setWorldConstructor(CustomWorld);

After(function(testCase) {
  if (testCase.result.status == Status.FAILED) {
    return this.driver.takeScreenshot().then( screenShot => {
      const filePath = `features/test_reports/${testCase.pickle.name.split(' ').join('_')}.png`;
      fse.outputFile(filePath, screenShot, { encoding: 'base64' }, err => {
        if (err) console.log(err)
        console.log("Screenshot created: ", filePath)
      });
    });
  }
});


BeforeAll(function() {
  driver = new Builder()
  .forBrowser('firefox')
  .setFirefoxOptions(firefoxOption())
  .build();
  driver.manage().setTimeouts({ implicit: 1000 });
  return driver.get(appUrl())
});

function firefoxOption() {
  // GitHub Actions set CI to true
  // Ref: https://docs.github.com/en/free-pro-team@latest/actions/reference/environment-variables#default-environment-variables
  return process.env.HEADLESS ? new firefox.Options().headless() : new firefox.Options()
}

AfterAll(function() {
  driver.quit();
});

/**
 * Sometimes booting Selenium or Webpack takes a while.
 * This should reduce test failures from that.
 */
setDefaultTimeout(30000);