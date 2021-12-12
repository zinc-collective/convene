const axios = require('axios');
class Api {
  constructor(host, apiKey) {
    this.host = host;
    this.apiKey = apiKey;
    this.axios  = axios.create({
        baseURL: host
      });

    // Alter defaults after instance has been created
    this.axios.defaults.headers.common['Authorization'] = `Token token="${apiKey}"`;
    this.axios.defaults.headers.common['Content-Type'] = 'application/json';
    this.axios.defaults.headers.common['Accept'] = 'application/json';
  }

  spaces() {
    return new Repository({ client: this, endpoint: '/spaces' });
  }

  post(path, model) {
    return this.axios.post(path, model)
  }
}
exports.Api = Api;
class Repository {
  constructor({ client, endpoint }) {
    this.client = client;
    this.endpoint = endpoint;
  }

  create(model) {
    return this.client.post(this.endpoint, model);
  }
}
