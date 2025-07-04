// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"

import Rails from "@rails/ujs"
Rails.start()
window.Rails = Rails

import "./controllers"
import * as bootstrap from "bootstrap"


document.addEventListener("turbo:load", () => {

  const flashMessages = document.querySelectorAll(".flash-message");

  flashMessages.forEach((msg) => {

    setTimeout(() => {
      msg.style.transition = "opacity 0.5s ease-out";
      msg.style.opacity = "0";

      // 完全に消す（DOMから削除）場合は以下も
      setTimeout(() => {
        msg.remove();
      }, 500);
    }, 3000); // 3秒後にフェード開始
  });
});

document.addEventListener("turbo:before-fetch-request", () => {
  if (window.location.pathname.includes("/gachas/result")) return;
  if (window.location.pathname.includes("/user_gacha_lists")) return;

  // 通常のスクロール位置保存
  const key = `scrollY:${location.pathname}`;
  sessionStorage.setItem(key, window.scrollY);
});

document.addEventListener("turbo:load", () => {
  if (window.location.pathname.includes("/gachas/result")) return;
  if (window.location.pathname.includes("/user_gacha_lists")) return;

  const scrollAfter = sessionStorage.getItem("scrollAfterSearchY");

  if (scrollAfter !== null) {
    // 検索後の強制スクロールが指定されているとき
    requestAnimationFrame(() => {
      window.scrollTo({ top: parseInt(scrollAfter, 10), behavior: "auto" });
      sessionStorage.removeItem("scrollAfterSearchY");
    });
    return;
  }

  // 通常スクロール復元
  const key = `scrollY:${location.pathname}`;
  const y = sessionStorage.getItem(key);
  if (y !== null) {
    window.scrollTo(0, parseInt(y, 10));
    sessionStorage.removeItem(key);
  }
});