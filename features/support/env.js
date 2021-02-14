const fse = require('fs-extra');
const { setWorldConstructor, After, setDefaultTimeout, Status } = require('cucumber');
const { Builder } = require('selenium-webdriver');
const firefox = require('selenium-webdriver/firefox');
const MailDev = require('maildev');

class CustomWorld {
  constructor() {
    this.driver = new Builder()
      .forBrowser('firefox')
      .setFirefoxOptions(this.firefoxOption())
      .build();
    // Figure out how to do this globally, now it's per world
    const this.maildev = new MailDev();
    this.maildev.listen()
  }

  firefoxOption() {
    // GitHub Actions set CI to true
    // Ref: https://docs.github.com/en/free-pro-team@latest/actions/reference/environment-variables#default-environment-variables
    return process.env.CI ? new firefox.Options().headless() : new firefox.Options()
  }
}

setWorldConstructor(CustomWorld);

After(function(testCase) {
  this.maildev.close();
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

setDefaultTimeout(10 * 2000);
