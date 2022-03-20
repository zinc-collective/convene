class SpaceMembership {
  constructor({ space, person }) {
    this.space = space
    this.person = person
  }

  asParams() {
    return {
      spaceId: this.space.id,
      personId: this.person.id
    }
  }
}

module.exports = SpaceMembership;