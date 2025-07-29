import { Controller } from "@hotwired/stimulus"

// HTML上で data-controller="password-toggle" を付けた要素に対応
export default class extends Controller {
  static targets = ["input", "icon"]

  toggle() {
    const input = this.inputTarget
    const icon = this.iconTarget

    const isHidden = input.type === "password"
    input.type = isHidden ? "text" : "password"

    // アイコン切り替え（Bootstrap Icons想定）
    icon.classList.toggle("bi-eye-slash", !isHidden)
    icon.classList.toggle("bi-eye", isHidden)
  }
}
