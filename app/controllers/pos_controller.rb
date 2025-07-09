class PosController < ApplicationController
  before_action :authenticate_user!

  def index
    @products = Product.includes(:product_variants).all
    @cart = session[:cart] || {}
  end

  def show
    @product = Product.find(params[:id])
    @variants = @product.product_variants

    # Available colors and sizes for selection UI
    @available_colors = @variants.pluck(:color).uniq
    @available_sizes = @variants.pluck(:size).uniq
  end

  def cart
    @cart = session[:cart] || {}
    @variants = ProductVariant.where(id: @cart.keys)
  end

  def add_to_cart
    session[:cart] ||= {}
    variant_id = params[:variant_id].to_s
    session[:cart][variant_id] ||= 0
    session[:cart][variant_id] += 1
    redirect_to pos_cart_path, notice: "Added one item."
  end

  def remove_from_cart
    session[:cart] ||= {}
    variant_id = params[:variant_id].to_s
    session[:cart].delete(variant_id)
    redirect_to pos_cart_path, notice: "Item removed."
  end

  def update_cart_item
    session[:cart] ||= {}
    variant_id = params[:variant_id].to_s
    quantity = params[:quantity].to_i
    if quantity > 0
      session[:cart][variant_id] = quantity
      flash[:notice] = "Quantity updated."
    else
      session[:cart].delete(variant_id)
      flash[:notice] = "Item removed because quantity is zero."
    end
    redirect_to pos_cart_path
  end

  def checkout
    @cart = session[:cart] || {}
    ActiveRecord::Base.transaction do
      order = Order.create!(total_price: 0, user: current_user)
      total = 0

      @cart.each do |variant_id, quantity|
        variant = ProductVariant.find(variant_id)
        raise ActiveRecord::Rollback, "Out of stock" if variant.stock < quantity

        variant.update!(stock: variant.stock - quantity) # ↓ subtract stock

        OrderItem.create!(order: order, product: variant.product, quantity: quantity)
        total += variant.product.price * quantity
      end

      order.update!(total_price: total)

      session[:cart] = {}
    end
    redirect_to pos_path, notice: "Order created successfully!"
  rescue ActiveRecord::RecordInvalid, ActiveRecord::Rollback => e
    redirect_to pos_cart_path, alert: "Order creation failed: #{e.message}"
  end
end
