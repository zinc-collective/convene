const fse = require('fs-extra');
const { setWorldConstructor, BeforeAll, After, setDefaultTimeout, Status } = require('cucumber');

const appUrl = require('../lib/appUrl')
const { Builder } = require('selenium-webdriver');
const firefox = require('selenium-webdriver/firefox');


class CustomWorld {
  constructor() {
    this.driver = new Builder()
      .forBrowser('firefox')
      .setFirefoxOptions(this.firefoxOption())
      .build();
    this.driver.manage().setTimeouts({ implicit: 1000 });
    /**
     * Warm up Selenium + Webpack to prevent test flakes
     */
    this.driver.get(appUrl())
  }

  firefoxOption() {
    // GitHub Actions set CI to true
    // Ref: https://docs.github.com/en/free-pro-team@latest/actions/reference/environment-variables#default-environment-variables
    return process.env.CI ? new firefox.Options().headless() : new firefox.Options()
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
        this.driver.quit();
      });
    });
  }
  this.driver.quit();
});

/**
 * Sometimes booting Selenium or Webpack takes a while.
 * This should reduce test failures from that.
 */
setDefaultTimeout(30000);