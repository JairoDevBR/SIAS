import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="character-count"
export default class extends Controller {
  static targets = ['counter']

  connect() {
  }

  updateCounter(event) {
    const numberOfCharacters = event.currentTarget.value.length;

    this.counterTarget.innerHTML = `Caracteres: ${numberOfCharacters}`;
  }
}
