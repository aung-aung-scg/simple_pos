// app/javascript/application.js
import "jquery";
import "bootstrap";  // This now includes Popper internally

// Initialize jQuery globally if needed
window.$ = window.jQuery = jQuery;

// Initialize Bootstrap components
const initBootstrap = () => {
  // Tooltips
  document.querySelectorAll('[data-bs-toggle="tooltip"]').forEach(el => {
    new bootstrap.Tooltip(el);
  });
  
  // Auto-dismiss alerts
  document.querySelectorAll('.alert').forEach(el => {
    setTimeout(() => {
      const alert = bootstrap.Alert.getOrCreateInstance(el);
      alert.close();
    }, 5000);
  });
};

// Initialize for both Turbo and regular page loads
document.addEventListener("turbo:load", initBootstrap);
document.addEventListener("DOMContentLoaded", initBootstrap);

// Cleanup before Turbo cache
document.addEventListener("turbo:before-cache", () => {
  document.querySelectorAll('[data-bs-toggle="tooltip"]').forEach(el => {
    const tooltip = bootstrap.Tooltip.getInstance(el);
    if (tooltip) tooltip.dispose();
  });
});
