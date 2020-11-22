import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "wrapper" ]

  toggle() {
    console.log("AWOOOOO")
    this.wrapperTarget.classList.toggle('--active')
  }

}
