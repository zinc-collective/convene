const getUrls = require("get-urls");
const { last } = require("lodash");
const { ThenableWebDriver } = require("selenium-webdriver");
const InvitationResponsePage = require("../harness/InvitationResponsePage");

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
const MailServer = require("./MailServer");

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
   * @returns
   */
  accept(driver) {
    return new InvitationResponsePage(driver, this).visit()
      .then((page) => page.submit())
  }

  /**
   * @returns {Promise<String>}
   */
  rsvpLink() {
    return this.latestDelivery().then((email) =>
      findUrl(email.text, /spaces\/.*\/invitations\/.*\/rsvp/)
    );
  }

  /**
   * @returns {Promise<MailServerEmail[]>}
   */
  emails() {
    return this.emailServer().emailsWhere({
      to: this.emailAddress,
      text: (text) => /You've been invited/.test(text),
    });
  }

  /**
   * @returns {MailServer}
   */
  emailServer() {
    return (this._emailServer = this._emailServer || new MailServer());
  }
}

module.exports = Invitation;
