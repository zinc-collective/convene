export default (function () {
  return process.env.APP_ROOT_URL
    ? process.env.APP_ROOT_URL
    : "http://127.0.0.1:3000";
});
