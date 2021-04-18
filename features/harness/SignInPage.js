const Page = require("./Page");

class SignInPage extends Page {
  enter() {
    return this.visit().then(() => this);
  }

  path() {
    return "/people/sign_in";
  }

  async submitEmail(email) {
    await this.component(".identification-form #passwordless_email").fillIn(
      email
    );
    await this.component(".identification-form input[type=submit]").click();
    return this;
  }
}

module.exports = SignInPage;
