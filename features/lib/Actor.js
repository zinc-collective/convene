import { ThenableWebDriver } from "selenium-webdriver";
import lodash from "lodash";
import getUrls from "get-urls";
import { MePage, SignInPage } from "../harness/Pages.js";
import MailServer from "./MailServer.js";
import PersonNavigationComponent from "../harness/PersonNavigationComponent.js";
const { last, result } = lodash;
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
  signIn(driver, space) {
    return this.isSignedIn(driver).then((signedIn) => {
      if (signedIn) {
        return this;
      }

      return new SignInPage(driver, space)
        .visit()
        .then((page) => page.submitEmail(this.email))
        .then(() => this.authenticationUrl())
        .then((authUrl) => driver.get(authUrl))
        .then(() => this);
    });
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
  authenticationUrl() {
    return this.authenticationEmail().then(
      (email) => getUrls(email.text).values().next().value,
    );
  }
  /**
   * The code a user can use to sign in
   * @returns {Promise<string>}
   */
  async authenticationCode() {
    return this.authenticationEmail().then(
      (email) => email.text.match(/password is (\d+)/)[1],
    );
  }
  /**
   * @returns {Promise<MailServerEmail[]>}
   */
  authenticationEmail() {
    return this.emails({ text: (t) => t.match(/password is (\d+)/) }).then(
      last,
    );
  }
  /**
   * @param {ThenableWebDriver} driver
   * @returns {Promise<boolean>}
   */
  isSignedIn(driver) {
    return new PersonNavigationComponent(driver, ".profile-menu")
      .signedInEmail()
      .then((email) => this.email == email);
  }
  /**
   * @param {MailQuery} query
   * @returns {Promise<MailServerEmail[]>}
   */
  emails(query) {
    return this.emailServer().emailsWhere({ ...query, to: this.email });
  }
  /**
   * @returns {MailServer}
   */
  emailServer() {
    return (this._emailServer = this._emailServier || new MailServer());
  }
}
export default Actor;
