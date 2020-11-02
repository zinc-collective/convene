const { setWorldConstructor, After, setDefaultTimeout, Status } = require('cucumber');
const { Builder } = require('selenium-webdriver');
const firefox = require('selenium-webdriver/firefox');

class CustomWorld {
  constructor({ attach }) {
    this.attach = attach;
    this.driver = new Builder()
      .forBrowser('firefox')
      .setFirefoxOptions(this.firefoxOption())
      .build();
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
      this.attach(screenShot, 'image/png');
      this.driver.quit()
    });
  }
  this.driver.quit();
});

setDefaultTimeout(10 * 2000);
