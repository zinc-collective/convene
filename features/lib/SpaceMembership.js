class SpaceMembership {
  constructor({ space, member }) {
    this.space = space
    this.member = member
  }

  asParams() {
    return {
      spaceId: this.space.id,
      memberId: this.member.id
    }
  }
}

module.exports = SpaceMembership;