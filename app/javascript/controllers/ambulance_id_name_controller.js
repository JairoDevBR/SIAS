import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="ambulance-id-name"
export default class extends Controller {
  static targets = ["worker1Id", "worker1Name", "worker2Id", "worker2Name"]
  static values = {
    login: String
  }

  connect() {
    console.log("hello world");
    console.log(this.worker1IdTarget);
  }

  fillName () {
    if (this.worker1IdTarget.value === "") {
      this.worker1NameTarget.value = "";
    } else {
      this.worker1NameTarget.value = JSON.parse(this.loginValue)[this.worker1IdTarget.value];
    }

    if (this.worker2IdTarget.value === "") {
      this.worker2NameTarget.value = "";
    } else {
      this.worker2NameTarget.value = JSON.parse(this.loginValue)[this.worker2IdTarget.value];
    }
  }
}
