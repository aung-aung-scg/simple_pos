// app/javascript/application.js
import jquery from "jquery"
import * as bootstrap from "bootstrap"

window.$ = window.jQuery = jquery;

document.addEventListener("turbo:load", () => {
  // Tooltips
  const tooltips = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
    .map(el => new bootstrap.Tooltip(el))
  
  // Auto-dismiss alerts
  const alerts = [].slice.call(document.querySelectorAll('.alert'))
    .map(el => {
      setTimeout(() => new bootstrap.Alert(el).close(), 5000)
    })
})
