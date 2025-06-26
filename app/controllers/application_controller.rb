class ApplicationController < ActionController::Base
  helper_method :current_user, :admin?

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def admin?
    current_user&.admin?
  end

  def authenticate_user!
    unless current_user
      store_location
      redirect_to login_path, alert: "Please login first"
    end
  end

  def authenticate_admin!
    unless admin?
      if current_user
        redirect_to root_path, alert: "Not authorized"
      else
        store_location
        redirect_to login_path, alert: "Please login as admin"
      end
    end
  end

  private

  def store_location
    session[:return_to] = request.fullpath if request.get?
  end

  def redirect_back_or(default)
    redirect_to(session.delete(:return_to) || default)
  end
end
