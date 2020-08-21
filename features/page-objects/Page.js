class Page {
  constructor(driver) {
    this.baseUrl = process.env.APP_URL ? process.env.APP_URL : 'http://localhost:3000';
    this.driver = driver;
  }
}

module.exports = Page;
