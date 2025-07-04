// controllers/search_form_controller.js
import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  connect() {
    console.log("✅ search_form_controller connected!");
  }

  submit(event) {
    console.log("🚀 submit triggered!");
    event.preventDefault(); // 通常送信を防ぐ

    const form = this.element;
    const url = new URL(form.action, window.location.origin);
    const params = new URLSearchParams(new FormData(form));
    url.search = params.toString();

    // ✅ 任意のスクロール位置に移動（例: 500px）
    window.scrollTo({ top: 1130, behavior: "smooth" });

    setTimeout(() => {
      Turbo.visit(url.toString());
    }, 600);
  }

  submitcounter(event) {
    console.log("🚀 submit triggered!");
    event.preventDefault(); // 通常送信を防ぐ

    const form = this.element;
    const url = new URL(form.action, window.location.origin);
    const params = new URLSearchParams(new FormData(form));
    url.search = params.toString();

    // ✅ 任意のスクロール位置に移動（例: 500px）
    window.scrollTo({ top: 550, behavior: "smooth" });
    setTimeout(() => {
      Turbo.visit(url.toString());
    }, 600);
  }
}
