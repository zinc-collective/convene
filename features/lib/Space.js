
class Space {
  constructor(spaceName) {
    this.name = spaceName;
    this.slug = spaceName.replace(/\s+/g, '-').toLowerCase();
    this.blueprint = 'system_test'
    this.client_attributes = { name: spaceName };
  }
}

module.exports = Space;
