class Admin::DashboardController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!

  def index
    @users_count = User.count
    @products_count = Product.count
    @orders_count = Order.count
  end
end
