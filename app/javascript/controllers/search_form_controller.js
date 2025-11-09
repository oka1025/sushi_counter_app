// controllers/search_form_controller.js
import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {

  submit(event) {

    event.preventDefault(); // 通常送信を防ぐ

    const form = this.element;
    const url = new URL(form.action, window.location.origin);
    const params = new URLSearchParams(new FormData(form));
    url.search = params.toString();

    // ✅ 任意のスクロール位置に移動（例: 500px）
    sessionStorage.setItem("scrollAfterSearchY", 1130);

    Turbo.visit(url.toString());
  }

  submitcounter(event) {
    event.preventDefault(); // 通常送信を防ぐ

    const form = this.element;
    const url = new URL(form.action, window.location.origin);
    const params = new URLSearchParams(new FormData(form));
    url.search = params.toString();

    // ✅ 任意のスクロール位置に移動（例: 500px）
    sessionStorage.setItem("scrollAfterSearchY", 550);

    Turbo.visit(url.toString());
  }
}
