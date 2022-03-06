
class AuthenticationMethod {
  constructor({ contactMethod, contactLocation} ) {
    this.contactMethod = contactMethod
    this.contactLocation = contactLocation
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