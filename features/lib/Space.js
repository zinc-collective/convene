
class Space {
  constructor({ name, slug, id }) {
    this.name = name;
    this.slug = slug || name.replace(/\s+/g, '-').toLowerCase();
    this.id = id;
  }

  asParams() {
    return {
      space: { name: this.name, slug: this.slug, blueprint: 'system_test', clientAttributes: { name: this.name } }
    }
  }
}

module.exports = Space;
