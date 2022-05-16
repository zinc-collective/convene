const { Given, DataTable } = require("@cucumber/cucumber");
Given('{a} {furniture} in {a} {entranceHall} to {space} is configured with:',
/**
 *
 * @this {CustomWorld}asd
 * @param {*} a
 * @param {Furniture} furniture
 * @param {*} a2
 * @param {Room} entranceHall
 * @param {Space} space
 * @param {DataTable} dataTable
 */
function (_a, furniture, _a2, room, space, dataTable) {


  return this.api()
  .rooms(space)
  .update(room.assign({
    furniturePlacementsAttributes: [furniture.assign(dataTable.hashes()).attributes()] }))
});
