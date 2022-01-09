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
      .then(() => this.submitButton().click())
      .then(() => this);
  }

  /**
   *
   * @param {String} code
   * @returns {Promise<this>}
   */
  submitCode(code) {
    return this.component('input[name="authenticated_session[one_time_password]"]')
      .fillIn(code)
      .then(() => this.submitButton().click())
      .finally(() => this)
  }

  submitButton() {
    return this.component("input[type=submit")
  }
}

module.exports = SignInPage;
