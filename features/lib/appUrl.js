module.exports = function() {
  return process.env.APP_URL ? process.env.APP_URL : 'http://localhost:3000';
}
