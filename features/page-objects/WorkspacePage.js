const Page = require("./Page");
const { By } = require('selenium-webdriver');

class WorkspacePage extends Page {
  constructor(driver) {
    super(driver);
  }

  enter(workspace) {
    this.driver.get(`${this.baseUrl}/workspaces/${workspace.slug}`);
  }

  findRoomCard(room) {
    return this.driver.findElement(By.css(`[name='${room.name}']`))
  }

  enterRoom(roomCard) {
    roomCard.findElement(By.linkText("Enter Room")).click();
  }
}

module.exports = WorkspacePage;
