import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "items" ]

  toggle() {
    this.itemsTarget.classList.toggle("hidden")
  }
}
