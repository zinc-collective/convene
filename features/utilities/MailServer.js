const axios = require("axios");

class MailServer {
  getAllEmails() {
    return axios.get("http://localhost:1080/email")
      .then(res => res.data)
      .catch(err => console.log(err))
  }

  deleteAllEmails() {
    return axios.delete("http://localhost:1080/email/all")
      .then(res => {
        if (res.status === 200) {
          return true
        }
      }).catch(err => console.log(err))
  }
}

module.exports = MailServer
