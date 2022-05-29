class Model {
  constructor() {
    this._attributes = {}
  }

  assign(attributes) {
    for(const attribute in attributes) {
      this._attributes[attribute] = attributes[attribute];
    }
    return this
  }

  get attributes() {
    return this._attributes;
  }

  set attributes(value) {
    this.assign(value)
  }
}

module.exports  = Model