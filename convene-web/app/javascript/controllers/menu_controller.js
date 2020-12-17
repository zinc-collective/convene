import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "button", "items" ]

  toggle() {
    this.itemsTarget.classList.toggle("hidden")
  }

  hide(e) {
    if (e.target === this.buttonTarget) {
      e.preventDefault()
      return false
    }
    this.itemsTarget.classList.add("hidden")
  }
}
