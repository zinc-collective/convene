const { Given, Then, DataTable } = require("@cucumber/cucumber");
const { assertDisplayed } = require("../support/assertDisplayed");
const { FurnitureComponent } = require("../harness/FurnitureComponent");

const dataTableToHash = function (dataTable) {
  return dataTable
    .rows()
    .reduce(
      (attributes, [name, value]) => (attributes[name] = value && attributes)
    );
};
Given(
  "{a} {furniture} in {a} {entranceHall} to {space} is configured with:",
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
      .update(
        room.assign({
          furniturePlacementsAttributes: [
            furniture.assign(dataTableToHash(dataTable)).attributes,
          ],
        })
      );
  }
);

Then(
  "{a} {furniture} is rendered with:",
  /**
   *
   * @param {*} _a
   * @param {Furniture} furniture
   * @param {DataTable} dataTable
   */
  function (_a, furniture, dataTable) {
    return assertDisplayed(
      new FurnitureComponent(this.driver, furniture.assign(dataTableTohash(dataTable.hashes())))
    );
  }
);
