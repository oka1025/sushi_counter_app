
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const key = `scrollY:${location.pathname}`;
    const y = sessionStorage.getItem(key);

    if (y !== null) {
      requestAnimationFrame(() => {
        window.scrollTo(0, parseInt(y, 10));
        sessionStorage.removeItem(key);
      });
    }
  }
}

// 保存処理：before unload や submit 時
document.addEventListener("turbo:before-fetch-request", () => {
  const key = `scrollY:${location.pathname}`;
  sessionStorage.setItem(key, window.scrollY);
});
