const Page = require("./Page");
const { By, until } = require('selenium-webdriver');

class WorkspacePage extends Page {
  constructor(driver) {
    super(driver);
  }

  enter(workspace) {
    this.driver.get(`${this.baseUrl}/workspaces/${workspace.slug}`);
  }

  enterRoom(room) {
    const roomCard = this.findRoomCard(room);
    roomCard.findElement(By.linkText("Enter Room")).click();
  }

  findRoomCard(room) {
    return this.driver.findElement(By.id(room.name))
  }

  async videoPanel() {
    await this.driver.wait(until.elementLocated(By.css("[name='jitsiConferenceFrame0']")));
    return await this.driver.findElement(By.css("[name='jitsiConferenceFrame0']"));
  }
}

module.exports = WorkspacePage;
