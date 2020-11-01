const Page = require("./Page");

class RoomSettingPage extends Page {
  constructor(driver, room) {
    super(driver);
    this.room = room;
  }

  async lock(accessCode) {
    await this.setAccessLevel('locked');
    await this.setAccessCode(accessCode);
    await this.clickUpdateRoom();
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
}

module.exports = RoomSettingPage;
