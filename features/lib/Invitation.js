import getUrls from "get-urls";
import lodash from "lodash";
import { ThenableWebDriver } from "selenium-webdriver";
import InvitationResponsePage from "../harness/InvitationResponsePage.js";
import MailServer from "./MailServer.js";
const { last } = lodash;
/**
 *
 * @param {String} text
 * @param {RegExp} regex
 * @returns
 */
function findUrl(text, regex) {
  for (let url of getUrls(text).values()) {
    if (url.match(regex)) {
      return url;
    }
  }
}
class Invitation {
  constructor(emailAddress) {
    this.emailAddress = emailAddress;
  }
  /**
   * @returns {Promise<Boolean>}
   */
  wasDelivered() {
    return this.latestDelivery().then((email) => !!email);
  }
  /**
   * @returns {Promise<MailServerEmail>}
   */
  latestDelivery() {
    return this.emails().then(last);
  }
  /**
   *
   * @param {ThenableWebDriver} driver
   * @returns {Promise<InvitationResponsePage>}
   */
  accept(driver) {
    return new InvitationResponsePage(driver, this)
      .visit()
      .then((page) => page.submit());
  }
  /**
   *
   * @param {ThenableWebDriver} driver
   * @returns {Promise<InvitationResponsePage>}
   */
  ignore(driver) {
    return new InvitationResponsePage(driver, this)
      .visit()
      .then((page) => page.ignoreButton().click());
  }

  /**
   * @returns {Promise<String>}
   */
  rsvpLink() {
    return this.latestDelivery().then((email) =>
      findUrl(email.text, /spaces\/.*\/invitations\/.*\/rsvp/),
    );
  }
  /**
   * @returns {Promise<MailServerEmail[]>}
   */
  emails() {
    return this.emailServer().emailsWhere({
      to: this.emailAddress,
      text: (text) => /invited you to/.test(text),
    });
  }
  /**
   * @returns {MailServer}
   */
  emailServer() {
    return (this._emailServer = this._emailServer || new MailServer());
  }
}
export default Invitation;
