import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.lastTouchTime = 0

    // ダブルタップだけ無効化（passive: false を指定）
    this.element.addEventListener('touchstart', this.preventDoubleTapZoom.bind(this), { passive: false })
  }

  preventDoubleTapZoom(e) {
    // 2本指以上ならズームを許可（ピンチズーム）
    if (e.touches.length > 1) return

    const now = new Date().getTime()
    if (now - this.lastTouchTime <= 300) {
      e.preventDefault() // ダブルタップを無効化
    }
    this.lastTouchTime = now
  }
}
