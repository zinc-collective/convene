const Page = require("./Page");

class SignInPage extends Page {
  constructor(driver, space) {
    super(driver);
    this.space = space;
  }

  path() {
    return `/spaces/${this.space.slug}/authenticated_session/new`;
  }

  submitEmail(email) {
    return this.component("input[type=email]")
      .fillIn(email)
      .then(() => this.component("input[type=submit]").click())
      .then(() => this);
  }
}

module.exports = SignInPage;
