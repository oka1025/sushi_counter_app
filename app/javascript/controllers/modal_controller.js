// app/javascript/controllers/modal_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay", "frame"]

  connect() {
    this.startObserver()
  }

  disconnect() {
    this.stopObserver()
  }

  show() {
    this.overlayTarget.classList.remove("d-none")
    this.frameTarget.classList.remove("d-none")
  }

  close() {
    this.overlayTarget.classList.add("d-none")
    this.frameTarget.classList.add("d-none")
  }

  outsideClick(event) {
    if (!this.frameTarget.contains(event.target)) {
      this.close()
    }
  }

  startObserver() {
    if (!this.frameTarget) {
      console.warn("frameTarget not found")
      return
    }

    this.observer = new MutationObserver((mutations) => {
      if (this.frameTarget.innerHTML.trim() === "") {
        this.close()
      }
    })

    this.observer.observe(this.frameTarget, {
      childList: true,
      subtree: true,
    })
  }

  stopObserver() {
    if (this.observer) {
      this.observer.disconnect()
    }
  }
}
