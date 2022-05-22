require('dotenv').config()
const fse = require('fs-extra');
const { setWorldConstructor, BeforeAll, AfterAll, After, setDefaultTimeout, Status } = require('@cucumber/cucumber');

const appUrl = require('../lib/appUrl');
const { CustomWorld } = require("./CustomWorld");
let { driver } = require('./driver')




setWorldConstructor(CustomWorld);

After(function(testCase) {
  if (testCase.result.status == Status.FAILED) {
    return driver.takeScreenshot().then( screenShot => {
      const filePath = `features/test_reports/${testCase.pickle.name.split(' ').join('_')}.png`;
      fse.outputFile(filePath, screenShot, { encoding: 'base64' }, err => {
        if (err) console.log(err)
        console.log("Screenshot created: ", filePath)
      });
    });
  }
});


BeforeAll(function() {
  return driver.get(appUrl())
});


AfterAll(function() {
  driver.quit();
});

/**
 * Sometimes booting Selenium or Webpack takes a while.
 * This should reduce test failures from that.
 */
setDefaultTimeout(30000);