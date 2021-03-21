const axios = require("axios");
const getUrls = require("get-urls");
const _ = require("lodash");

class MailServer {
  async getLastAuthenticationLink(actor) {
    const lastEmail = await this.getLastEmail(actor);
    return getUrls(lastEmail.text).values().next().value;
  }

  getLastEmail(actor) {
    return this.getAllEmails().then((emails) => {
      return _.findLast(emails, (email) => email.headers.to === actor.email);
    });
  }

  getAllEmails() {
    return axios
      .get("http://localhost:1080/email")
      .then((res) => res.data)
      .catch((err) => console.log(err));
  }
}

module.exports = MailServer;