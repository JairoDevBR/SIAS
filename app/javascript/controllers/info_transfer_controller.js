import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="info-transfer"
export default class extends Controller {
  static targets = ["streetInput", "streetOutput","neighborhoodInput", "neighborhoodOutput","cityInput", "cityOutput", "categoryInput", "categoryOutput", "latitudeInput", "latitudeOutput", "longitudeInput", "longitudeOutput"]

  connect() {

  }

  send(){
  this.streetOutputTarget.value = this.streetInputTarget.value
  this.neighborhoodOutputTarget.value = this.neighborhoodInputTarget.value
  this.cityOutputTarget.value = this.cityInputTarget.value
  this.categoryOutputTarget.value = this.categoryInputTarget.value
  this.latitudeOutputTarget.value = this.latitudeInputTarget.value
  this.longitudeOutputTarget.value = this.longitudeInputTarget.value
  }
}
