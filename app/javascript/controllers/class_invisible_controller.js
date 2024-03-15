import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="class-invisible"
export default class extends Controller {
  static targets = ["classe", "background"]

  connect() {
  }

  invisible() {
    this.classeTarget.classList.add('invisible')
    this.backgroundTarget.classList.add('invisible')
  }
}
