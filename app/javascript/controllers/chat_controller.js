import { Controller } from "@hotwired/stimulus"

// Gère le défilement automatique et la réinitialisation du formulaire de chat.
export default class extends Controller {
  static targets = ["messages", "form"]

  connect() {
    this.scrollToBottom()
    if (this.hasMessagesTarget) {
      this.observer = new MutationObserver(() => this.scrollToBottom())
      this.observer.observe(this.messagesTarget, { childList: true })
    }
  }

  disconnect() {
    if (this.observer) this.observer.disconnect()
  }

  reset(event) {
    if (event.detail && event.detail.success === false) return
    if (this.hasFormTarget) this.formTarget.reset()
  }

  scrollToBottom() {
    if (this.hasMessagesTarget) {
      this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
    }
  }
}
