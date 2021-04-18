const Page = require("./Page");
const { last } = require("lodash");

const valueFromText = (text) => last(text.split(": "));
class MePage extends Page {
  path() {
    return "/me";
  }

  async person() {
    return { id: this.id(), name: this.name(), email: this.email() };
  }

  /**
   * @return {Promise<string>}
   */
  id() {
    return this.component("main > ul.person > li.id")
      .text()
      .then(valueFromText);
  }

  /**
   * @return {Promise<string>}
   */
  name() {
    return this.component("main > ul.person > li.name")
      .text()
      .then(valueFromText);
  }

  /**
   * @return {Promise<string>}
   */
  email() {
    return this.component("main > ul.person > li.email")
      .text()
      .then(valueFromText);
  }
}

module.exports = MePage;
