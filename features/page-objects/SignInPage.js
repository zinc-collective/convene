const Page = require("./Page")

class SignInPage extends Page {
  async enter() {
    await this.driver.get(`${this.baseUrl}/people/sign_in`);
    return this;
  }

  async submitEmail(email) {
    await this.enter();
    const emailInput = await this.findByCss(".identification-form #passwordless_email");
    emailInput.sendKeys(email);
    const submitButton = await this.findByCss(".identification-form input[type=submit]");
    return submitButton.click();
  }
}

module.exports = SignInPage
