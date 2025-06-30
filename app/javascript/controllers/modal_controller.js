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
    console.log("🔍 overlay:", this.overlayTarget)
    console.log("🔍 frame:", this.frameTarget)
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

  setContent(event) {
    const imageUrl = event.currentTarget.dataset.image
    const name = event.currentTarget.dataset.name
    const rarity = event.currentTarget.dataset.rarity
  
    const rarityLabel = {
      normal: "ノーマル",
      rare: "レア",
      super_rare: "スーパーレア",
      special: "スペシャル"
    }[rarity] || "？？？"
  
    const rarityClass = {
      normal: "rarity-normal",
      rare: "bg-primary text-white",
      super_rare: "rarity-super_rare",
      special: "bg-warning text-dark"
    }[rarity] || "bg-light text-muted"
  
    this.frameTarget.innerHTML = `
      <div class="text-center position-relative d-inline-block">
        <img src="${imageUrl}" alt="${name}" class="img-fluid" style="max-height: 310px;" />
        <div class="position-absolute top-0 end-0 px-2 py-1 mt-1 small rounded ${rarityClass}" style="z-index: 10;">
          ${rarityLabel}
        </div>
        <h5 class="mt-2">${name}</h5>
      </div>
    `
  
    this.show()
  }

}
