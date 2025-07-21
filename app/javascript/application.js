// app/javascript/application.js

import "jquery"
import "bootstrap"
import "@hotwired/turbo-rails"
import "./controllers" // this loads Stimulus controllers

// ✅ Make jQuery globally available
window.$ = window.jQuery = $;

// Confirm it's working
console.log("✅ jQuery initialized:", $);

// Optional: Bootstrap auto-dismiss alerts and tooltips
$(document).on("turbo:load", function () {
  $('[data-bs-toggle="tooltip"]').each(function () {
    new bootstrap.Tooltip(this);
  });

  $('.alert').each(function () {
    setTimeout(() => {
      bootstrap.Alert.getOrCreateInstance(this).close();
    }, 5000);
  });
});
