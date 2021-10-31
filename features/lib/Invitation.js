const { SpaceEditPage } = require("../harness/Pages");
const { findLast, find, filter } = require("lodash");
const getUrls = require("get-urls");

/**
 *
 * @param {String} text
 * @param {RegExp} regex
 * @returns
 */
function findUrl(text, regex) {
  for(let url  of getUrls(text).values()) {
    if(url.match(regex)) { return url  }
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
    return this.emails().then((emails) => emails[0]);
  }

  /**
   * @returns {Promise<Boolean>}
   */
  hasStatus({ status, space, driver }) {
    const matcher = new RegExp(`<${this.emailAddress}>.*${status}`)
    return new SpaceEditPage(driver, space).visit().then(
      (page) => page.hasContent(matcher)
    )
  }


  /**
   * @returns {Promise<String>}
   */
  rsvpLink() {
    return this.latestDelivery().then(
      (email) => findUrl(email.text, /spaces\/.*\/invitations\/.*\/rsvp/)
    );
  }

  /**
   * @returns {Promise<MailServerEmail[]>}
   */
  emails() {
    return this.emailServer()
      .emailsTo(this.emailAddress)
      .then((emails) =>
        filter(emails, (email) => /You've been invited/.test(email.text))
      );
  }

  /**
   * @returns {MailServer}
   */
  emailServer() {
    return (this._emailServer = this._emailServer || new MailServer());
  }
}

module.exports = Invitation;
