import { When } from "@cucumber/cucumber";
When('the {actor} hit the back button', async function (actor) {
    await this.driver.navigate().back();
});
