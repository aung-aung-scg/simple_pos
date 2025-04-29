// app/javascript/application.js

// Rails 7+ Turbo (required)
import "@hotwired/turbo-rails"

// Initialize Bootstrap tooltips AFTER Turbo loads
document.addEventListener("turbo:load", () => {
  // Initialize tooltips
  const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
  tooltipTriggerList.forEach((tooltipTriggerEl) => {
    new bootstrap.Tooltip(tooltipTriggerEl)
  })
  
  // Initialize Bootstrap (if needed)
  if (typeof bootstrap !== 'undefined') {
    bootstrap.Tooltip.init()
  }
})