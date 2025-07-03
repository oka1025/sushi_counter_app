import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const key = `scrollY:${location.pathname}`;
    const y = localStorage.getItem(key);

    if (y) {
      requestAnimationFrame(() => {
        window.scrollTo(0, parseInt(y));
        localStorage.removeItem(key);
      });
    }
  }
}

// グローバルイベントリスナー
document.addEventListener("turbo:before-visit", () => {
  const key = `scrollY:${location.pathname}`;
  localStorage.setItem(key, window.scrollY);
});

document.addEventListener("turbo:submit-start", () => {
  const key = `scrollY:${location.pathname}`;
  localStorage.setItem(key, window.scrollY);
});
