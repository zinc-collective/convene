const Page = require("./Page");
const WaitingRoomPage = require ("./WaitingRoomPage")

class RoomSettingPage extends Page {
  constructor(driver, room) {
    super(driver);
    this.room = room;
  }

  async lock(accessCode) {
    await this.setAccessLevel('locked');
    await this.setAccessCode(accessCode);
    return this.clickUpdateRoom();
  }

  async unlock(accessCode) {
    const waitingRoom = new WaitingRoomPage(this.driver)
    await waitingRoom.submitAccessCode(accessCode)

    await this.setAccessLevel('unlocked');
    return this.clickUpdateRoom();
  }

  async setAccessLevel(accessLevel) {
    const accessLevelSelect = await this.findByCss("[id='room_access_level']");
    accessLevelSelect.click();

    const accessLevelOption = await this.findByCss(`[value=${accessLevel}]`);
    return accessLevelOption.click();
  }

  async setAccessCode(accessCode) {
    const accessCodeInput = await this.findByCss("[id='room_access_code']");
    return accessCodeInput.sendKeys(accessCode.value);
  }

  async clickUpdateRoom() {
    const submitInput = await this.findByCss("[type='submit']");
    return submitInput.click();
  }

  async accessCodeError() {
    const errorElement = await this.findByCss('.field_with_errors input[name="room[access_code]"]');
    return errorElement.isDisplayed();
  }
}

module.exports = RoomSettingPage;
