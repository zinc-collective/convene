const axios = require("axios");
const { camelCase } = require('change-case');
const applyCaseMiddleware = require("axios-case-converter").default;
const Space = require("./Space");
class Api {
  constructor(host, apiKey) {
    this.host = host;
    this.apiKey = apiKey;
    this.axios = applyCaseMiddleware(
      axios.create({
        baseURL: host,
      })
    );

    // Alter defaults after instance has been created
    this.axios.defaults.headers.common[
      "Authorization"
    ] = `Token token="${apiKey}"`;
    this.axios.defaults.headers.common["Content-Type"] = "application/json";
    this.axios.defaults.headers.common["Accept"] = "application/json";
  }

  /**
   * @returns {Repository}
   */
  spaces() {
    return new Repository({ client: this, endpoint: "/spaces", model: Space });
  }

  post(path, model) {
    return this.axios.post(path, model.asParams()).catch(function (error) {
      console.error(`Can't POST to ${path}`);
      console.error(model.asParams());
      throw error;
    });
  }
}
exports.Api = Api;
class Repository {
  constructor({ client, endpoint, model }) {
    this.client = client;
    this.endpoint = endpoint;
    this.model = model;
  }

  create(data) {
    const model = this.model;
    return this.client.post(this.endpoint, data).then(function (response) {
      const data = response.data[camelCase(model.name)] || response.data;
      return new model(data);
    })
  }

  findOrCreateBy(data) {
    return this.create(data);
  }
}
