import "jquery"
import * as bootstrap from "bootstrap"
import "@hotwired/turbo-rails"

// Initialize Bootstrap tooltips AFTER Turbo loads
document.addEventListener("turbo:load", () => {
  const tooltipTriggerList = Array.from(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
  tooltipTriggerList.forEach(el => new bootstrap.Tooltip(el))
})
