class Api {
  constructor(host, apiKey) {
    this.host = host;
    this.apiKey = apiKey;
  }

  spaces() {
    return new Repository({ client: this, endpoint: '/spaces' });
  }

  post(path, model) {
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
