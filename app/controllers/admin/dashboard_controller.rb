class Admin::DashboardController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!

  def index
    @users_count = User.count
    @products_count = Product.count
    @orders_count = Order.count
    @pending_orders_count = Order.where(status: 'pending').count

    @products_growth = calculate_growth(Product.where('created_at >= ?', 1.month.ago).count, Product.count)
    @orders_growth = calculate_growth(Order.where('created_at >= ?', 1.week.ago).count, Order.count)
    @new_users_this_week = User.where('created_at >= ?', 1.week.ago).count

    # Recent activity
    @recent_orders = Order.order(created_at: :desc).limit(5)
    @recent_users = User.order(created_at: :desc).limit(3)
    @recent_product_updates = Product.order(updated_at: :desc).limit(3)
  end

  private

  def calculate_growth(recent_count, total_count)
    return 0 if total_count == 0
    ((recent_count.to_f / total_count) * 100).round
  end
end
