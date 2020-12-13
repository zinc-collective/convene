const Page = require("./Page")

class WaitingRoomPage extends Page {
  constructor(driver) {
    super(driver);
  }

  async submitAccessCode(accessCode) {
    const accessCodeInput = await this.findByCss("[id='waiting_room_access_code']");
    if ( accessCodeInput.isDisplayed() ) {
      accessCodeInput.sendKeys(accessCode.value)
      const submitInput = await this.findByCss("[type='submit']")
      return submitInput.click()
    }
    return true
  }
}

module.exports = WaitingRoomPage
