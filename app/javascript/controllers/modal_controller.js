// app/javascript/controllers/modal_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay", "frame"]

  connect() {
    console.log("modal#connect")
    this.startObserver()
  }

  disconnect() {
    console.log("modal#disconnect")
    this.stopObserver()
  }

  show() {
    console.log("modal#show")
    this.overlayTarget.classList.remove("d-none")
    this.frameTarget.classList.remove("d-none")
  }

  close() {
    console.log("modal#close")
    this.overlayTarget.classList.add("d-none")
    this.frameTarget.classList.add("d-none")
  }

  outsideClick(event) {
    console.log("modal#outsideObserver")

    if (!this.frameTarget.contains(event.target)) {
      this.close()
    }
  }

  startObserver() {
    console.log("modal#startObserver")

    if (!this.frameTarget) {
      console.warn("frameTarget not found")
      return
    }

    this.observer = new MutationObserver((mutations) => {
      console.log("MutationObserver triggered. Content:", this.frameTarget.innerHTML)
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
      console.log("modal#stopObserver")
    }
  }
}
