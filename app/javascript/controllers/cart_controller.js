import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["qtyInput", "subtotal", "row", "total"]

  async updateQuantity(event) {
    const input = event.currentTarget
    const variantId = input.dataset.cartVariantId
    const quantity = input.value

    const token = document.querySelector('meta[name="csrf-token"]').getAttribute('content')

    try {
      const response = await fetch(`/cart/update/${variantId}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': token,
          'Accept': 'application/json'
        },
        body: JSON.stringify({ quantity: quantity })
      })

      if (response.ok) {
        const data = await response.json()
        document.getElementById(`subtotal-${variantId}`).textContent = `MMK ${data.subtotal.toLocaleString()}`
        const totalEl = document.getElementById('cart-total')
        if (totalEl) totalEl.textContent = `MMK ${data.total.toLocaleString()}`
      }
    } catch (error) {
      console.error("Update failed:", error)
    }
  }

  async removeItem(event) {
    const button = event.currentTarget
    const variantId = button.dataset.cartVariantId
    const token = document.querySelector('meta[name="csrf-token"]').getAttribute('content')

    try {
      const response = await fetch(`/cart/remove/${variantId}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': token,
          'Accept': 'application/json'
        }
      })

      if (response.ok) {
        const data = await response.json()
        const rowEl = document.getElementById(`cart-row-${variantId}`)
        if (rowEl) rowEl.remove()
        const totalEl = document.getElementById('cart-total')
        if (totalEl) totalEl.textContent = `MMK ${data.total.toLocaleString()}`
      }
    } catch (error) {
      console.error("Remove failed:", error)
    }
  }
}
