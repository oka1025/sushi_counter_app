import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "icon"]
  static classes = ["visible", "hidden"]

  connect() {
    this.hidden = true
    this.update()
  }

  toggle() {
    this.hidden = !this.hidden
    this.update()
  }

  update() {
    this.inputTarget.type = this.hidden ? "password" : "text"
    this.iconTarget.classList.toggle("bi-eye-slash", this.hidden)
    this.iconTarget.classList.toggle("bi-eye", !this.hidden)
  }
}
