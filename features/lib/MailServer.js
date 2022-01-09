const axios = require("axios");
const { filter, last } = require("lodash");
var promiseRetry = require("promise-retry");

/**
 * Adapter connecting our test suite to our mail handler
 * @see {@link https://github.com/maildev/maildev/}
 */
class MailServer {
  /**
   * @param {MailQuery} query
   * @returns {Promise<MailServerEmail[]>}
   */
  emailsWhere(query) {
    return promiseRetry((retry) => {
      return this.emails()
        .then((emails) =>
          filter(emails, (email) => email.headers.to === query.to)
        )
        .then((emails) =>
          filter(emails, (email) =>
            query.text ? query.text(email.text) : true
          )
        )
        .then((emails) => (emails.length > 0 ? emails : retry()));
    });
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
 * @typedef {Object} MailQuery
 * @property {string} to - Filter the email address
 * @property {function} [text] - Callback to limit to only emails that match the given text
 */

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
