const Page = require("./Page");

class MePage extends Page {
  constructor(driver) {
    super(driver);
  }

  visit() {
    return this.driver.get(`${this.baseUrl}/me.json`);
  }

  async person() {
    const jsonEl = await this.findByCss("#json");
    const json = await jsonEl.getText();
    return JSON.parse(json).person;
  }

  async email() {
    return (await this.person()).email;
  }

  async id() {
    return (await this.person()).id;
  }

}

module.exports = MePage;
