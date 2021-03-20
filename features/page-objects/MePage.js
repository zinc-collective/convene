const Page = require("./Page");
const _ = require("lodash");

class MePage extends Page {
  constructor(driver) {
    super(driver);
  }

  visit() {
    return this.driver.get(`${this.baseUrl}/me`);
  }

  async person() {
    const idEl = await this.findByCss("main > ul.person > li.id");
    const id = _.last((await idEl.getText()).split(": "));
    const nameEl = await this.findByCss("main > ul.person > li.name");
    const name = _.last((await nameEl.getText()).split(": "));
    const emailEl = await this.findByCss("main > ul.person > li.email");
    const email = _.last((await emailEl.getText()).split(": "));

    return { id, name, email };
  }
}

module.exports = MePage;
