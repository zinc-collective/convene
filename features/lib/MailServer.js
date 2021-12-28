const axios = require("axios");
const { filter, last } = require("lodash");
var promiseRetry = require('promise-retry');

/**
 * Adapter connecting our test suite to our mail handler
 * @see {@link https://github.com/maildev/maildev/}
 */
class MailServer {
  /**
   * Retrieves the latest email to the given email address
   * @param {string} emailAddress
   * @returns {Promise<MailServerEmail>}
   */

  lastEmailTo(emailAddress) {
    return this.emailsTo(emailAddress).then((emails) => last(emails));
  }

  /**
   * Retrieves all emails to the given email address
   * @param {string} emailAddress
   * @returns {Promise<MailServerEmail[]>}
   */
  emailsTo(emailAddress) {
    return promiseRetry((retry) => {
      return this.emails()
        .then((emails) => filter(emails, (email) => email.headers.to === emailAddress))
        .then((emails) => emails.length > 0 ? emails : retry());
    })
  }

  /**
   * Retrieves all emails sent
   * @returns {Promise<MailServerEmail[]>}
   */
  emails() {
    return axios
      .get("http://localhost:1080/email")
      .then((res) => res.data)
      .catch((err) => console.log(err));
  }
}

/**
 * An Email, as returned from MailDev's REST Api
 * @typedef {Object} MailServerEmail
 * @property {MailServerEmailHeaders} headers
 * @property {string} text
 * @see {@link https://github.com/maildev/maildev/blob/master/docs/rest.md}
 */

/**
 * @typedef {Object} MailServerEmailHeaders
 * @property {string} to
 */

module.exports = MailServer;
