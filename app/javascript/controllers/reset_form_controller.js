// app/javascript/controllers/reset_form_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form"]

  reset() {
    const form = this.formTarget

    // input, select, textarea をすべてクリア
    form.querySelectorAll("input[name^='q'], select[name^='q'], textarea[name^='q']").forEach(el => {
      if (el.type === "checkbox" || el.type === "radio") {
        el.checked = false
      } else {
        el.value = ""
      }
    })
  }
}
