const Page = require("./Page")

class SignInPage extends Page {
  enter() {
    return this.driver.get(`${this.baseUrl}/people/sign_in`);
  }

  async submitEmail(email) {
    const emailInput = await this.findByCss(".identification-form #passwordless_email");
    emailInput.sendKeys(email);
    const submitButton = await this.findByCss(".identification-form input[type=submit]");
    return submitButton.click();
  }
}

module.exports = SignInPage
