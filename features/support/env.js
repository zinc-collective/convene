const fs = require('fs');
const { setWorldConstructor, After, setDefaultTimeout, Status } = require('cucumber');
const { Builder } = require('selenium-webdriver');
const firefox = require('selenium-webdriver/firefox');

class CustomWorld {
  constructor() {
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
  // TODO: This block of code will capture screenshot and write as a png file but also ignore failed test cases.
  //       Ideaily we'd like to use https://www.npmjs.com/package/cucumber-html-reporter but
  //       I have been getting error when using it, see: https://github.com/zinc-collective/convene/pull/147
  //       I am keeping this code uncommented here so it's easier to enable this to get screenshot on CI
  //       if I still haven't figure out how to use cucumber-html-reporter..
  // if (testCase.result.status == Status.FAILED) {
  //   return this.driver.takeScreenshot().then( screenShot => {
  //     const filePath = `features/test_reports/${testCase.pickle.name.split(' ').join('_')}.png`;
  //     fs.writeFile(filePath, screenShot, { encoding: 'base64' }, err => {
  //       if (err) console.log(err)
  //       console.log("Screenshot created: ", filePath)
  //       process.exit(0);
  //     })
  //     // TODO: Uncomment this once figure out how to build test report
  //     // this.attach(screenShot, 'image/png');
  //     this.driver.quit();
  //   });
  // }
  this.driver.quit();
});

setDefaultTimeout(10 * 2000);
