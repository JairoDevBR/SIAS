import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="ambulance-id-name"
export default class extends Controller {
  static targets = ["worker1Id", "worker1Nname", "worker2Id", "worker2Name"]
  // static value

  connect() {
    console.log("hello world");
    console.log(this.worker1IdTarget);
  }

  fillName () {
    this.worker1IdTarget.value
    // acess this value and use the key to input name
  }

}
