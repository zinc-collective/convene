class Model {
  assign(attributes) {
    for(const attribute in attributes) {
      this[attribute] = attributes[attribute];
    }
    return this
  }
}

module.exports  = Model