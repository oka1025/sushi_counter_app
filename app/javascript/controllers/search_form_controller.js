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

    // スクロール位置保存
    const key = `scrollY:${location.pathname}`;
    sessionStorage.setItem(key, window.scrollY);

    // Turbo による遷移（SPA的に動作）
    Turbo.visit(url.toString());
  }
}
