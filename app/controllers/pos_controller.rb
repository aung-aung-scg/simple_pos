class PosController < ApplicationController
  def index
    @products = Product.all
    @cart = session[:cart] || {}
  end

  def add_to_cart
    session[:cart] ||= {}
    product_id = params[:product_id].to_s
    session[:cart][product_id] ||= 0
    session[:cart][product_id] += 1
    redirect_to root_path
  end

  def checkout
    @cart = session[:cart] || {}
    order = Order.create(total_price: 0)

    total = 0
    @cart.each do |product_id, quantity|
      product = Product.find(product_id)
      OrderItem.create(order: order, product: product, quantity: quantity)
      total += product.price * quantity
    end

    order.update(total_price: total)

    session[:cart] = {}

    redirect_to root_path, notice: "Order ##{order.id} created! Total: #{order.total_price}"
  end
end
