// app/javascript/controllers/modal_close_hook_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  close() {
    document.dispatchEvent(new Event("close-modal"))
  }
}
