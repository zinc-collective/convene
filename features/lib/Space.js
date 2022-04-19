
class Space {
  constructor(spaceName) {
    this.name = spaceName;
    this.slug = spaceName.replace(/\s+/g, '-').toLowerCase();
    this.blueprint = 'system_test'
  }
}

module.exports = Space;