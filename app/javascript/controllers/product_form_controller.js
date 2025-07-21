import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["subcategorySelect", "mainImageUpload"]

  connect() {
    this.variantIndex = document.querySelectorAll(".variant-card").length;
    this.initImageValidation();
    this.initAddVariant();
    this.initRemoveVariant();
  }

  loadSubcategories(event) {
    const gender = event.target.value;
    const subcategorySelect = this.subcategorySelectTarget;

    if (gender) {
      fetch(`/admin/categories/subcategories?gender=${encodeURIComponent(gender)}`)
        .then(response => response.json())
        .then(data => {
          subcategorySelect.innerHTML = '<option value="">Select Subcategory</option>';
          data.forEach(category => {
            const option = new Option(category.name, category.id);
            subcategorySelect.add(option);
          });
          subcategorySelect.disabled = false;
        });
    } else {
      subcategorySelect.innerHTML = '<option value="">Select Subcategory</option>';
      subcategorySelect.disabled = true;
    }
  }

  initAddVariant() {
    const addBtn = document.getElementById("add-variant-btn");
    const variantsWrapper = document.getElementById("variants");

    addBtn?.addEventListener("click", (e) => {
      e.preventDefault();
      const index = this.variantIndex;
      const wrapper = document.createElement("div");
      wrapper.className = "variant-card card mb-3";
      wrapper.innerHTML = `
        <div class="card-body">
          <div class="row g-3">
            <div class="col-md-3">
              <label class="form-label small fw-bold">Color</label>
              <input type="text" name="product[product_variants_attributes][${index}][color]" class="form-control" required placeholder="e.g. Black">
            </div>
            <div class="col-md-3">
              <label class="form-label small fw-bold">Size</label>
              <input type="text" name="product[product_variants_attributes][${index}][size]" class="form-control" required placeholder="e.g. M, XL">
            </div>
            <div class="col-md-2">
              <label class="form-label small fw-bold">Stock</label>
              <input type="number" name="product[product_variants_attributes][${index}][stock]" class="form-control" required placeholder="0">
            </div>
            <div class="col-md-3">
              <label class="form-label small fw-bold">Image</label>
              <input type="file" name="product[product_variants_attributes][${index}][image]" class="form-control" accept="image/*">
            </div>
            <div class="col-md-1 d-flex align-items-end">
              <button type="button" class="btn btn-danger btn-sm remove-variant">
                <i class="bi bi-trash"></i>
              </button>
            </div>
          </div>
        </div>
      `;
      variantsWrapper.appendChild(wrapper);
      this.variantIndex++;
    });
  }

  initRemoveVariant() {
    document.addEventListener("click", (e) => {
      if (e.target.closest(".remove-variant")) {
        e.preventDefault();
        e.target.closest(".variant-card").remove();
      }
    });
  }

  initImageValidation() {
    const imageInput = this.mainImageUploadTarget;
    if (!imageInput) return;

    const maxSize = parseInt(imageInput.dataset.maxSize) || 5 * 1024 * 1024;
    const allowedTypes = ['image/jpeg', 'image/png', 'image/jpg'];

    imageInput.addEventListener("change", function () {
      const file = this.files[0];
      const container = this.closest(".file-upload-area");
      const previewContainer = container.querySelector(".image-preview-container");
      const errorDiv = container.querySelector(".invalid-feedback");

      container.classList.remove("border-danger");
      if (errorDiv) errorDiv.remove();
      previewContainer.innerHTML = "";

      if (file) {
        if (!allowedTypes.includes(file.type)) {
          showImageError(container, "Only JPEG or PNG images are allowed");
          this.value = "";
          return;
        }

        if (file.size > maxSize) {
          showImageError(container, "Image must be smaller than 5MB");
          this.value = "";
          return;
        }

        const img = document.createElement("img");
        img.src = URL.createObjectURL(file);
        img.className = "img-thumbnail mt-2";
        img.style.maxHeight = "150px";
        img.onload = () => URL.revokeObjectURL(img.src);
        previewContainer.appendChild(img);
      }

      function showImageError(container, message) {
        container.classList.add("border-danger");
        const div = document.createElement("div");
        div.className = "invalid-feedback d-block text-danger";
        div.innerHTML = `<i class="fas fa-exclamation-circle me-1"></i>${message}`;
        container.appendChild(div);
      }
    });
  }
}
