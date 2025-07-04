
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    if (window.location.pathname.includes("/gachas/result")) return;
    if (window.location.pathname.includes("/user_gacha_lists")) return;
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
