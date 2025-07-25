// app/javascript/controllers/flash_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    setTimeout(() => {
      this.element.style.transition = "opacity 0.5s ease-out"
      this.element.style.opacity = "0"

      setTimeout(() => {
        this.element.remove()
      }, 500)
    }, 3000) // 3秒後にフェードアウト
  }
}
