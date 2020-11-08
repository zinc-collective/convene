const concatRegExp = (...regex) => {
  return new RegExp(regex.map(re => re.source).join(''))
};

module.exports = concatRegExp;
