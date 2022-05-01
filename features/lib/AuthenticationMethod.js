
class AuthenticationMethod {
  constructor({ id, contactMethod, contactLocation, person }) {
    this.id = id
    this.contactMethod = contactMethod
    this.contactLocation = contactLocation
    this.person = person
  }

  asParams() {
    return {
      authenticationMethod: {
        contactMethod: this.contactMethod,
        contactLocation: this.contactLocation,
      }
    }

  }
}

module.exports = AuthenticationMethod;