import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="info-transfer"
export default class extends Controller {
  static targets = ["streetInput", "streetOutput","neighborhoodInput", "neighborhoodOutput","cityInput", "cityOutput"]

  connect() {

  }

  send(){
  console.log("ssss");
  this.streetOutputTarget.value = this.streetInputTarget.value
  this.neighborhoodOutputTarget.value = this.neighborhoodInputTarget.value
  this.cityOutputTarget.value = this.cityInputTarget.value
  }
}
