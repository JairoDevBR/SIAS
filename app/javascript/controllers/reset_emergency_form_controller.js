import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="reset-emergency-form"
export default class extends Controller {

  refreshPage() {
    window.location.reload();
  }
}
