const axios = require("axios");
const { camelCase } = require("change-case");
const Room = require("./Room");
const applyCaseMiddleware = require("axios-case-converter").default;
const Space = require("./Space");
class Api {
  constructor(host, apiKey) {
    this.host = host;
    this.apiKey = apiKey;
    this.axios = applyCaseMiddleware(
      axios.create({
        baseURL: host,
        headers: {
          Authorization: `Token token="${apiKey}"`,
          "Content-Type": "application/json",
          Accept: "application/json",
        },
      })
    );
  }

  /**
   * @returns {Repository}
   */
  spaces() {
    return new Repository({ client: this, endpoint: "/spaces", model: Space });
  }

  /**
   *
   * @param {Space} space
   * @returns
   */
  rooms(space) {
    return new Repository({
      client: this,
      endpoint: `/spaces/${space.slug}/rooms`,
      model: Room,
    });
  }

  post(path, model) {
    return this.axios.post(path, model.asParams()).catch(function (error) {
      console.error(`Can't POST to ${path}`);
      console.error(model.asParams());
      throw error;
    });
  }
  put(path, model) {
    return this.axios.put(path, model.asParams()).catch(function (error) {
      console.error(`Can't PUT to ${path}`);
      console.error({ model });
      console.error({ error });
      throw error;
    });
  }
  get(path) {
    return this.axios.get(path).catch(function (error) {
      console.error(`Can't get ${path}`);
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

  create(model) {
    return this.client
      .post(this.endpoint, model)
      .then((response) => this.castToModel(response));
  }

  /**
   *
   * @param {any} object
   * @returns {Promise<any>}
   */
  findBy(object) {
    return this.client
      .get(`/spaces/${object.space.slug}${this.endpoint}/${object.slug}`)
      .then((response) => this.castToModel(response));
  }

  update(model) {
    return this.client
      .put(`${this.endpoint}/${model.slug}`, model)
      .then((response) => this.castToModel(response));
  }

  findOrCreateBy(data) {
    return this.create(data);
  }

  castToModel(response) {
    const model = this.model;

    const data = response.data[camelCase(model.name)] || response.data;
    return new model(data);
  }
}
