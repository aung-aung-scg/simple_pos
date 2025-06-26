class ApplicationController < ActionController::Base
  helper_method :admin?

  def admin?
    current_user&.admin?
  end

  def authenticate_admin!
    unless current_user
      redirect_to new_user_session_path, alert: "Please login"
    else
      unless admin?
        redirect_to root_path, alert: "Not authorized"
      end
    end
  end

  # Optional: Customize post-login path
  def after_sign_in_path_for(resource)
    resource.admin? ? admin_root_path : pos_path
  end
end
