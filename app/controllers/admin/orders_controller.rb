class Admin::OrdersController < ApplicationController
  include ErrorHandler
  layout "admin"
  before_action :authenticate_admin!
  before_action :set_order, only: [:show, :destroy]

  def index
    @orders = Order.includes(:user, order_items: { product: :product_variants })
                  .references(:user)
                  .order("orders.#{sort_column} #{sort_direction}")

    # Filter by email
    if params[:email].present?
      @orders = @orders.joins(:user)
                      .where("LOWER(users.email) LIKE ?", "%#{params[:email].downcase}%")
    end

    # Filter by date range
    if params[:start_date].present? && params[:end_date].present?
      begin
        start_date = Date.parse(params[:start_date])
        end_date   = Date.parse(params[:end_date])
        @orders = @orders.where(orders: { created_at: start_date.beginning_of_day..end_date.end_of_day })
      rescue ArgumentError
        # ignore invalid dates
      end
    elsif params[:start_date].present?
      start_date = Date.parse(params[:start_date]) rescue nil
      @orders = @orders.where("orders.created_at >= ?", start_date.beginning_of_day) if start_date
    elsif params[:end_date].present?
      end_date = Date.parse(params[:end_date]) rescue nil
      @orders = @orders.where("orders.created_at <= ?", end_date.end_of_day) if end_date
    end
    @orders = @orders.page(params[:page]).per(25)
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
