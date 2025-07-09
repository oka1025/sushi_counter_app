import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="autocomplete"
export default class extends Controller {
  static targets = ["input", "results"]

  connect() {
    console.log("autocomplete_controller connected!");
    this.url = this.inputTarget.dataset.autocompleteUrl
    this.resultsTarget.innerHTML = ""
    this.timeout = null
  }

  search() {
    clearTimeout(this.timeout)

    const term = this.inputTarget.value
    if (term.length < 1) {
      this.resultsTarget.innerHTML = ""
      return
    }

    this.timeout = setTimeout(() => {
      fetch(`${this.url}?term=${encodeURIComponent(term)}`)
        .then(response => response.json())
        .then(data => {
          this.resultsTarget.innerHTML = ""

          data.forEach(name => {
            const li = document.createElement("li")
            li.textContent = name
            li.classList.add("autocomplete-item")
            li.style.cursor = "pointer"
            li.addEventListener("click", () => {
              this.inputTarget.value = name
              this.resultsTarget.innerHTML = ""
            })
            this.resultsTarget.appendChild(li)
          })
        })
    })
  }
}
