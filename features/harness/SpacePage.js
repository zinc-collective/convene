const { By, until } = require("selenium-webdriver");
const assert = require("assert").strict;

const Page = require('./Page')
const RoomPage = require("./RoomPage");

const Room = require('../lib/Room')

const Component = require('./Component');
const RoomCardComponent = require('./RoomCardComponent');

class SpacePage extends Page {
  constructor(driver, space) {
    super(driver);
    this.space = space;
  }

  /**
   * @returns {string}
   */
  path() {
    return `/spaces/${this.space.slug}`
  }

  /**
   * @param {Room} room
   * @returns {RoomCardComponent}
   */
  roomCard(room) {
    return new RoomCardComponent(this.driver, room)
  }

  /**
   *
   * @param {*} filters
   * @returns {Promise<RoomCardComponent[]}
   */
  roomCardsWhere(filters) {
    const { accessLevel } = filters
    return this.driver.findElements(accessLevel.locator).then(
      (elements) => elements.map((e) => new RoomCardComponent(e))
    );
  }
}

module.exports = SpacePage;