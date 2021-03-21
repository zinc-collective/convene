const { ThenableWebDriver } = require("selenium-webdriver");

const { findLast, find, filter } = require("lodash");
const getUrls = require("get-urls");
const { MePage, SignInPage } = require("../harness/Pages");

const MailServer = require("./MailServer");
const Space = require("./Space");

class Actor {
  constructor(type) {
    this.type = type;
    this.email = `${type.replace(/\s/g, "+").toLowerCase()}@example.com`;
  }

  /**
   * Signs in to the application via email
   * @param {ThenableWebDriver} driver
   * @returns {Promise<Actor>}
   */

  async signIn(driver) {
    const signInPage = new SignInPage(driver);
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
    const email = await this.emailServer().lastEmailTo(this.email);

    return getUrls(email.text).values().next().value;
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
