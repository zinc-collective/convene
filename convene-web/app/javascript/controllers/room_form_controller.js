import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "accessCode" ]

  accessLevelToggle() {
    this.accessCodeTarget.disabled = !this.accessCodeTarget.disabled
  }
}
