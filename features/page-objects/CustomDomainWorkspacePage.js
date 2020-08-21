const WorkspacePage = require("./WorkspacePage");

class CustomDomainWorkspacePage extends WorkspacePage {
  constructor(driver, customDomain) {
    this.customDomain = customDomain;
    super(driver);
  }

  enter() {
    this.driver.get(`${this.customDomain}`);
  }

  enterRoomThruUrl(room) {
    this.driver.get(`${this.customDomain}/${room.slug}`);
  }
}

module.exports = CustomDomainWorkspacePage;