import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

export default class extends Controller {
  static values = { chatId: Number }
  static targets = ["posts", "form"]

  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: "ChatChannel", id: this.chatIdValue },
      { received: data =>
        this.#insertPost(data)
      },
    )
      console.log(this.chatIdValue);
  }

    #insertPost(data) {
      this.postsTarget.insertAdjacentHTML('beforeend', data);
      this.postsTarget.scrollTo(0, this.postsTarget.scrollHeight);
      this.formTarget.reset();
  }
}
