import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="section-form"
export default class extends Controller {
  handleMarkRemove() {
    this.element.querySelector("img").classList.toggle("invisible");
  }
}
