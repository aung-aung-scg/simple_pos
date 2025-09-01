class PosController < ApplicationController
  before_action :authenticate_user!

  def index
    # Base query with eager loading
    @products = Product.includes(:product_variants, :category).where(archived: false)

    # Apply category filters
    if params[:category].present?
      category = Category.find_by(id: params[:category])

      if category.present?
        if category.parent_id.nil?
          # Main category selected (Men/Women/Kids)
          @products = @products.where(gender: category.name.downcase)
          @subcategories = category.subcategories
        else
          # Subcategory selected
          @products = @products.where(category_id: category.id)
          @subcategories = category.parent.subcategories
        end
      end
    end

    # Apply additional filters
    @products = @products
      .then { |relation| filter_by_price(relation) }
      .then { |relation| filter_by_stock(relation) }
      .then { |relation| search_products(relation) }
      .then { |relation| sort_products(relation) }
      .page(params[:page]).per(12)

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
    @variants = ProductVariant.where(id: @cart.keys).includes(:product)
    @total = calculate_cart_total
  end

  def add_to_cart
    session[:cart] ||= {}
    variant_id = params[:variant_id].to_s
    session[:cart][variant_id] ||= 0
    session[:cart][variant_id] += 1
    # render_cart_json(variant_id)
    redirect_to cart_pos_path, notice: "Added one item."
  end

  def update_cart_item
    session[:cart] ||= {}
    variant_id = params[:variant_id].to_s
    quantity = params[:quantity].to_i
    if quantity > 0
      session[:cart][variant_id] = quantity
    else
      session[:cart].delete(variant_id)
    end

    variant = ProductVariant.find_by(id: variant_id)
    subtotal = variant ? variant.product.price * (session[:cart][variant_id] || 0) : 0
    total = calculate_cart_total
    render json: { subtotal: subtotal, total: total }
  end

  def remove_from_cart
    session[:cart] ||= {}
    variant_id = params[:variant_id].to_s
    session[:cart].delete(variant_id)
    total = calculate_cart_total
    render json: { total: total }
  end

  def prepare_checkout
    if session[:cart].blank?
      redirect_to pos_cart_path, alert: "Your cart is empty"
    else
      redirect_to confirm_order_pos_path
    end
  end

  def confirm_order
    @cart = session[:cart] || {}
    @variants = ProductVariant.where(id: @cart.keys).includes(:product)
    @total = calculate_cart_total
    respond_to do |format|
      format.html { render :confirm_order, status: :ok }
    end
  end

  def checkout
    @cart = session[:cart] || {}
    unless current_user.phone.present? && current_user.address.present?
      redirect_to edit_user_path(current_user),
                  alert: "Please complete your phone number and address before checkout"
      return
    end

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
      redirect_to pos_path, notice: "Order created successfully!"
    end
  rescue => e
    redirect_to cart_pos_path, alert: "Checkout failed: #{e.message}"
  end

  private

  def do_search(products)
    if params[:query].present?
      products = products.where("name ILIKE :q OR description ILIKE :q", q: "%#{params[:query]}%")
    end
    products
  end

  def filter_by_price(products)
    case params[:price]
    when 'under_10k' then products.where('price < ?', 10_000)
    when '10k_30k'   then products.where(price: 10_000..30_000)
    when '30k_50k'   then products.where(price: 30_000..50_000)
    when 'over_50k'  then products.where('price > ?', 50_000)
    else products
    end
  end

  def filter_by_stock(products)
    case params[:stock]
    when 'in_stock'  then products.joins(:product_variants).where('product_variants.stock > 0').distinct
    when 'low_stock' then products.joins(:product_variants).where('product_variants.stock BETWEEN 1 AND 20').distinct
    when 'sold_out'  then products.joins(:product_variants).where('product_variants.stock <= 0').distinct
    else products
    end
  end

  def search_products(products)
    if params[:query].present?
      products.where("products.name ILIKE :query OR products.description ILIKE :query", query: "%#{params[:query]}%")
    else
      products
    end
  end

  def sort_products(products)
    case params[:sort]
    when 'newest'       then products.order(created_at: :desc)
    when 'price_asc'    then products.order(price: :asc)
    when 'price_desc'   then products.order(price: :desc)
    when 'best_selling' then products.left_joins(:order_items).group(:id).order('COUNT(order_items.id) DESC')
    else products.order(created_at: :desc) # Default sorting
    end
  end

  def do_sort(products)
    sort_key = params[:sort_key].presence_in(Product.column_names + ['price']) || 'created_at'
    sort_order = params[:sort_order].in?(%w[asc desc]) ? params[:sort_order] : 'desc'
    products.order("#{sort_key} #{sort_order}")
  end

  def calculate_cart_total
    total = 0
    (session[:cart] || {}).each do |variant_id, quantity|
      variant = ProductVariant.find_by(id: variant_id)
      next unless variant
      total += variant.product.price * quantity
    end
    total
  end

  def render_cart_json(variant_id)
    variant = ProductVariant.find_by(id: variant_id)
    subtotal = variant ? variant.product.price * (session[:cart][variant_id] || 0) : 0
    total = calculate_cart_total

    render json: {
      variant_id: variant_id.to_i,
      quantity: session[:cart][variant_id] || 0,
      variant_subtotal: subtotal,
      total: total
    }
  end
end
