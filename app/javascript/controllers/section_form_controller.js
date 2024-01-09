import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="section-form"
export default class extends Controller {
  // Toggles visibility of the Section image when selecting for removeal
  handleMarkRemove() {
    this.element.querySelector("img").classList.toggle("invisible");
  }
}
