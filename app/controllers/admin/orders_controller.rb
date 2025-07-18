class Admin::OrdersController < ApplicationController
  include ErrorHandler
  layout "admin"
  before_action :authenticate_admin!
  before_action :set_order, only: [:show, :destroy]

  def index
    @orders = Order.includes(:user, order_items: { product: :product_variants })
                 .order("#{sort_column} #{sort_direction}")
                 .page(params[:page]).per(25)
  end

  def show
  end

  def destroy
    if @order.destroy
      redirect_to admin_orders_path, notice: "Order ##{@order.id} was successfully deleted."
    else
      redirect_to admin_orders_path,
                  alert: "Failed to delete order: #{@order.errors.full_messages.to_sentence}"
    end
  end

  def update_status
    @order = Order.find(params[:id])
    if @order.update(status: params[:status])
      redirect_to admin_orders_path, notice: "Order status updated"
    else
      redirect_to admin_orders_path, alert: "Failed to update status"
    end
  end

  private

  def set_order
    @order = Order.includes(order_items: { product: :product_variants }).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_orders_path, alert: "Order not found."
  end
  def sort_column
    %w[id created_at updated_at status total_price].include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end
