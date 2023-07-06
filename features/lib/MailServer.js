import axios from "axios";
import lodash from "lodash";
import promiseRetry from "promise-retry";
const { filter, last } = lodash;
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
    return promiseRetry(
      (retry) => {
        return this.emails()
          .then((emails) =>
            filter(emails, (email) => email.headers.to === query.to),
          )
          .then((emails) =>
            filter(emails, (email) =>
              query.text ? query.text(email.text) : true,
            ),
          )
          .then((emails) => (emails.length > 0 ? emails : retry()));
      },
      { maxRetryTime: 2000 },
    ).catch(() => {
      throw `Couldn't find email ${JSON.stringify(query)}`;
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
export default MailServer;
