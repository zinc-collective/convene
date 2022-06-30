import Space from "./Space.js";
export default (function linkParameters({
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
});
