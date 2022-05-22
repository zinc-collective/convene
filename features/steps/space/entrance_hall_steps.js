const { Given, DataTable } = require("@cucumber/cucumber");
const { Space, Room } = require("../../lib");
const { CustomWorld } = require("../../support/CustomWorld");

Given('{a} {entranceHall} to {space}\'s has {a} following Furniture:',
/**
 * @this {CustomWorld}
 * @param {*} a
 * @param {Room} room
 * @param {Space} space

 * @param {dataTable} dataTable
 * @returns {Promise<Room>}
 */
function (_a, room, space, _a2, dataTable) {
    const furniturePlacementsAttributes = dataTable.hashes()
    .map(
      (x) => ({ ...x, furnitureAttributes: JSON.parse(x.furnitureAttributes) }))
    return this.api()
      .rooms(space)
      .update(room.assign({ furniturePlacementsAttributes }))
  }
);
