import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "icon"]

  toggle() {
    const oldInput = this.inputTarget
    const icon = this.iconTarget
    const isHidden = oldInput.type === "password"

    // input を複製して type を変更
    const newInput = oldInput.cloneNode(true)
    newInput.type = isHidden ? "text" : "password"
    newInput.setAttribute("data-password-toggle-target", "input")

    // replace input (Safari対策)
    oldInput.replaceWith(newInput)

    // アイコン切り替え
    icon.classList.toggle("bi-eye-slash", !isHidden)
    icon.classList.toggle("bi-eye", isHidden)
  }
}
