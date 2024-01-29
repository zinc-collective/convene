import { Builder } from "selenium-webdriver";
import firefox from "selenium-webdriver/firefox.js";
let driver;
driver = new Builder()
  .forBrowser("firefox")
  .setFirefoxOptions(firefoxOption())
  .build();
driver.manage().setTimeouts({ implicit: 1000 });
function firefoxOption() {
  return process.env.HEADLESS
    ? new firefox.Options().addArguments("--headless")
    : new firefox.Options();
}
export { driver };
