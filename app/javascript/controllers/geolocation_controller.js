import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="geolocation"
export default class extends Controller {
  getPosition() {
    navigator.geolocation.getCurrentPosition((position) => {
      console.log(position);
    })
  }

  connect() {
    window.setInterval(() => this.getPosition(), 30000)
  }
}
