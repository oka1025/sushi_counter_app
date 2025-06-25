import { Controller } from "@hotwired/stimulus"
import * as bootstrap from "bootstrap"

export default class extends Controller {
  static values = { id: String }

  connect() {

    this.panel = document.getElementById(this.idValue)

    // 保存された状態を反映（open or closed）
    const savedState = localStorage.getItem(`collapse-${this.idValue}`)
    if (savedState === "open") {
      this.panel.classList.add("show")
    } else {
      this.panel.classList.remove("show")
    }

    // Bootstrap Collapse API を使ってイベントを監視
    const collapse = new bootstrap.Collapse(this.panel, {
      toggle: false // 勝手に開かないようにする
    })

    this.panel.addEventListener("shown.bs.collapse", () => {
      localStorage.setItem(`collapse-${this.idValue}`, "open")
    })

    this.panel.addEventListener("hidden.bs.collapse", () => {
      localStorage.setItem(`collapse-${this.idValue}`, "closed")
    })
  }
}
