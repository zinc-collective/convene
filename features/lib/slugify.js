
/**
 *
 * @param {string} str
 * @returns {string}
 */
module.exports = function slugify(str) {
  return str.replace(/\s+/g, "-").toLowerCase();
}