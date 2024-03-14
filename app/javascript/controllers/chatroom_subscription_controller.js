import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

export default class extends Controller {
  static values = { chatroomId: Number, scheduleId: Number }
  static targets = ["messages", "form"]

  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: "ChatroomChannel", id: 1 },
      {
        received: data => {
          if (data.type === "emergency") {
            if (this.scheduleIdValue == data.scheduleId) {
              window.location.replace(`/emergencies/${data.emergencyId}`);
            }
          }
          else this.insertMessage(data);
        },
      },
    )

    console.log(`Subscribe to the chatroom with the id ${1}.`)
  }

  insertMessage(data) {
    this.messagesTarget.insertAdjacentHTML('beforeend', data);
    this.messagesTarget.scrollTo(0, this.messagesTarget.scrollHeight);
    this.formTarget.reset();
  }
}
