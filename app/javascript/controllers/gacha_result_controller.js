import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["flash", "result"]

  connect() {
    console.log("gacha-result controller connected");

    // 画像が全て読み込まれるのを待つ
    const images = this.resultTarget.querySelectorAll("img");
    const loadPromises = Array.from(images).map(img => {
      return new Promise(resolve => {
        if (img.complete) {
          resolve(); // すでに読み込み済み
        } else {
          img.addEventListener("load", resolve);
          img.addEventListener("error", resolve); // エラーでも resolve しておく
        }
      });
    });

    Promise.all(loadPromises).then(() => {
      setTimeout(() => {
        this.flashTarget.classList.add("fade-out");

        // フェードが終わるまで少し待ってから表示変更
        setTimeout(() => {
          this.flashTarget.remove();
          this.resultTarget.classList.remove("opacity-20");
          this.resultTarget.classList.add("opacity-100");
          document.getElementById("back-button")?.classList.remove("d-none");
        }, 1300); // fade-out に合わせる
      }, 300);
    });
  }
}
