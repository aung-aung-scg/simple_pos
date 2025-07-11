class PosController < ApplicationController
  before_action :authenticate_user!

  def index
    @products = Product.includes(:product_variants).all
    @products = do_search(@products)
    @products = do_filter(@products)
    @products = do_sort(@products)
    @products = @products.page(params[:page]).per(9)
    @cart = session[:cart] || {}
  end

  def show
    @product = Product.find(params[:id])
    @variants = @product.product_variants.includes(image_attachment: :blob)

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
        # Lock the product variant row for concurrency safety
        variant = ProductVariant.lock.find(variant_id)

        if variant.stock < quantity
          # Rollback if not enough stock for this variant
          raise ActiveRecord::Rollback, "Out of stock for variant ID #{variant_id}"
        end

        # Reduce the variant stock
        variant.update!(stock: variant.stock - quantity)

        # Create order item with correct associations
        OrderItem.create!(
          order_id: order.id,
          product_id: variant.product_id,
          product_variant_id: variant.id,
          quantity: quantity,
          unit_price: variant.product.price
        )

        # Calculate total price (product price * quantity)
        total += variant.product.price * quantity
      end

      # Update order total price
      order.update!(total_price: total)

      # Clear cart after successful checkout
      session[:cart] = {}
    end
    redirect_to pos_path, notice: "Order created successfully!"
  rescue ActiveRecord::RecordInvalid, ActiveRecord::Rollback => e
    redirect_to pos_cart_path, alert: "Order creation failed: #{e.message}"
  end

  private

  def do_search(products)
    if params[:query].present?
      products = products.where("name ILIKE :q OR description ILIKE :q", q: "%#{params[:query]}%")
    end
    products
  end

  def do_filter(products)
    case params[:stock]
    when "in_stock"
      products = products.joins(:product_variants).where("product_variants.stock > 0").distinct
    when "sold_out"
      products = products.joins(:product_variants).where("product_variants.stock <= 0").distinct
    end
    products
  end

  def do_sort(products)
    sort_key = params[:sort_key].presence_in(Product.column_names + ['price']) || 'created_at'
    sort_order = params[:sort_order].in?(%w[asc desc]) ? params[:sort_order] : 'desc'
    products.order("#{sort_key} #{sort_order}")
  end
end
