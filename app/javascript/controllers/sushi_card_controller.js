// app/javascript/controllers/sushi_card_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("sushi_card controller connected")

    // gesture イベントを無効化
    this.element.addEventListener('gesturestart', this.prevent)
    this.element.addEventListener('gesturechange', this.prevent)
    this.element.addEventListener('gestureend', this.prevent)

    // 連続タップによる挙動無効化
    this.lastTouch = 0
    this.element.addEventListener('touchstart', this.handleTouchStart.bind(this), { passive: false })
  }

  prevent(e) {
    e.preventDefault()
  }

  handleTouchStart(e) {
    const now = new Date().getTime()
    if (now - this.lastTouch <= 300) {
      e.preventDefault()
    }
    this.lastTouch = now
  }
}
