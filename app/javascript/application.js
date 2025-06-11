// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"

import Rails from "@rails/ujs"
Rails.start()
window.Rails = Rails

import "./controllers"
import * as bootstrap from "bootstrap"


document.addEventListener("turbo:load", () => {
  console.log("🔥 turbo:load event fired"); // ← これが出れば動いてる！

  const flashMessages = document.querySelectorAll(".flash-message");

  flashMessages.forEach((msg) => {
    console.log("🙌 flash message found:", msg.innerText); // ← これも表示されるか？

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
