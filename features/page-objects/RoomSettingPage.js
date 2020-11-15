const Page = require("./Page");

class RoomSettingPage extends Page {
  constructor(driver, room, accessCode) {
    super(driver);
    this.room = room;
    this.accessCode = accessCode;
  }

  async lock(accessCode) {
    await this.setAccessLevel('locked');
    await this.setAccessCode(accessCode);
    await this.clickUpdateRoom();
  }

  async unlock() {
    await this.enterAccessCode()
    await this.setAccessLevel('unlocked');
    await this.clickUpdateRoom();
  }

  async enterAccessCode() {
    const accessCodeInput = await this.findByCss("[id='waiting_room_access_code']");
    accessCodeInput.sendKeys(this.accessCode);
    const submitInput = await this.findByCss("[type='submit']");
    submitInput.click();
  }

  async setAccessLevel(accessLevel) {
    const accessLevelSelect = await this.findByCss("[id='room_access_level']");
    accessLevelSelect.click();

    const accessLevelOption = await this.findByCss(`[value=${accessLevel}]`);
    accessLevelOption.click();
  }

  async setAccessCode(accessCode) {
    const accessCodeInput = await this.findByCss("[id='room_access_code']");
    accessCodeInput.sendKeys(accessCode);
  }

  async clickUpdateRoom() {
    const submitInput = await this.findByCss("[type='submit']");
    submitInput.click();
  }

  async accessCodeError() {
    const errorElement = await this.findByCss('.field_with_errors input[name="room[access_code]"]');
    return errorElement.isDisplayed();
  }
}

module.exports = RoomSettingPage;
