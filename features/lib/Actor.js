const { ThenableWebDriver } = require("selenium-webdriver");

const { last } = require("lodash");
const getUrls = require("get-urls");
const { MePage, SignInPage } = require("../harness/Pages");

const MailServer = require("./MailServer");
const Space = require("./Space");

class Actor {
  constructor(type, email) {
    this.type = type;
    this.email = email;
  }

  /**
   * Signs in to the application via email
   * @param {ThenableWebDriver} driver
   * @returns {Promise<Actor>}
   */
  async signIn(driver, space) {
    const signInPage = new SignInPage(driver, space);
    await signInPage.visit().then((page) => page.submitEmail(this.email));

    return driver.get(await this.authenticationUrl()).then(() => this);
  }

  signOut(driver) {
    return new MePage(driver)
      .visit()
      .then((page) => page.personNavigation().signOut());
  }

  /**
   * The URL for a user to authenticate
   * @returns {Promise<string>}
   */
  async authenticationUrl() {
    const email = await this.emailServer()
      .emailsWhere({ to: this.email })
      .then(last);
    return getUrls(email.text).values().next().value;
  }

  /**
   * The code a user can use to sign in
   * @returns {Promise<string>}
   */
  async authenticationCode() {
    const email = await this.emailServer()
      .emailsWhere({
        to: this.email,
        text: (t) => t.match(/password is (\d+)/),
      })
      .then(last);

    return email.text.match(/password is (\d+)/)[1];
  }

  /**
   * @returns {Promise<MailServerEmail[]>}
   */
  emails() {
    return this.emailServer.emailsTo(this.email);
  }

  /**
   * @returns {MailServer}
   */
  emailServer() {
    return (this._emailServer = this._emailServier || new MailServer());
  }
}

module.exports = Actor;
