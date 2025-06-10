// app/javascript/controllers/modal_close_hook_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  close() {
    console.log("modal-close-hook#close called 🚀")
    document.dispatchEvent(new Event("close-modal"))
  }
}
