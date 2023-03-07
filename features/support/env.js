import { config } from "dotenv";
import fse from "fs-extra";
import {
  setWorldConstructor,
  BeforeAll,
  AfterAll,
  After,
  setDefaultTimeout,
  Status,
} from "@cucumber/cucumber";
import appUrl from "../lib/appUrl.js";
import { CustomWorld } from "./CustomWorld.js";
import { driver } from "./driver.js";
({ config }).config();
setWorldConstructor(CustomWorld);
After(function (testCase) {
  if (testCase.result.status == Status.FAILED) {
    return driver.takeScreenshot().then((screenShot) => {
      const filePath = `features/test_reports/${testCase.pickle.name
        .split(" ")
        .join("_")}.png`;
      fse.outputFile(filePath, screenShot, { encoding: "base64" }, (err) => {
        if (err) console.log(err);
        console.log("Screenshot created: ", filePath);
      });
    });
  }
});
BeforeAll(function () {
  return driver.get(appUrl());
});
AfterAll(function () {
  driver.quit();
});
/**
 * Sometimes booting Selenium or Webpack takes a while.
 * This should reduce test failures from that.
 */
setDefaultTimeout(30000);
