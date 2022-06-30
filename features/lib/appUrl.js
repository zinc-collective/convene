export default (function () {
  return process.env.APP_ROOT_URL
    ? process.env.APP_ROOT_URL
    : "http://localhost:3000";
});
