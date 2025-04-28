class ApplicationController < ActionController::Base
  helper_method :current_user, :admin?

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def admin?
    current_user&.admin?
  end

  def authenticate_user!
    redirect_to login_path, alert: "Please login first" unless current_user
  end

  def authenticate_admin!
    unless admin?
      redirect_to root_path, alert: "Not authorized"
    end
  end
end
