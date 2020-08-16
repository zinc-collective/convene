class Page {
  constructor(driver, baseUrl = 'http://localhost:3000') {
    this.baseUrl = baseUrl;
    this.driver = driver;
  }
}

module.exports = Page;
