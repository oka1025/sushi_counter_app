import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["flash", "result"]

  connect() {
    console.log("gacha-result controller connected")

    // フェードアウト開始
    this.flashTarget.classList.add("fade-out")

    // 終了後に flash を削除し、画像の不透明度とボタン表示を切り替え
    setTimeout(() => {
      this.flashTarget.remove()
      this.resultTarget.classList.remove("opacity-20")
      document.getElementById("back-button")?.classList.remove("d-none")
    }, 1000)
  }
}
