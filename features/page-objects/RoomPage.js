const Page = require("./Page");

class RoomPage extends Page {
  constructor(driver) {
    super(driver);
  }

  async isWaitingRoom() {
    const accessCodeForm = await this.findByCss("[class='access-code-form']");
    return accessCodeForm.isDisplayed();
  }
}

module.exports = RoomPage;
