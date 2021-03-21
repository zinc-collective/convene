class AccessCode {
  constructor(validity) {
    this.validity = validity
  }

  get value() {
    if(this.isValid()) {
      return "secret"
    } else if (this.validity == "empty") {
      return ""
    } else {
      return "wrong"
    }
  }

  isValid() {
    return this.validity == "correct" || this.validity == "valid"
  }
}

module.exports = AccessCode;