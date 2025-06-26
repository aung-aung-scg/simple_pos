# app/controllers/admin/orders_controller.rb
class Admin::OrdersController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!

  def index
    @orders = Order.includes(:user, order_items: :product).order(created_at: :desc)
  end

  def show
    @order = Order.includes(order_items: :product).find(params[:id])
  end

  def destroy
    @order = Order.find_by(id: params[:id])
    if @order&.destroy
      redirect_to admin_orders_path, notice: "Order deleted."
    else
      redirect_to admin_orders_path, alert: "Failed to delete order."
    end
  end
end
