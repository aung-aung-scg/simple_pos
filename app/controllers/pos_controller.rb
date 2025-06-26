class PosController < ApplicationController
  before_action :authenticate_user!

  def index
    @products = Product.all
    @cart = session[:cart] || {}
  end

  def add_to_cart
    session[:cart] ||= {}
    product_id = params[:product_id].to_s
    session[:cart][product_id] ||= 0
    session[:cart][product_id] += 1
    redirect_to pos_path
  end

  def show
    @cart = session[:cart] || {}
    @products = Product.where(id: @cart.keys)
  end

  def checkout
    @cart = session[:cart] || {}
    ActiveRecord::Base.transaction do
      order = Order.create!(total_price: 0 , user: current_user)
      total = 0
      @cart.each do |product_id, quantity|
        product = Product.find(product_id)
        OrderItem.create!(order: order, product: product, quantity: quantity)
        total += product.price * quantity
      end

      order.update!(total_price: total)

      session[:cart] = {}
    end
    redirect_to pos_path, notice: "Order created successfully!"
  rescue ActiveRecord::RecordInvalid => e
    redirect_to pos_cart_path, alert: "Order creation failed: #{e.message}"
  end
end
