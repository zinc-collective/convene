const Space = require("./Space");
/**
 * Merges extracted parameter types together for convenience within step definitions
 */
module.exports = function linkParameters({
  space = new Space({ name: "System Test" }),
  accessLevel,
  room,
}) {
  room.space = space;
  room.reinitialize({ accessLevel });
  return {
    space,
    accessLevel,
    room,
  };
};
