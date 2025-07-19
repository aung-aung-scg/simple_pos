class ApplicationController < ActionController::Base
  helper_method :admin?
  before_action :configure_permitted_parameters, if: :devise_controller?

  def admin?
    current_user&.admin?
  end

  def authenticate_admin!
    unless current_user
      redirect_to new_user_session_path, alert: "Please login"
    else
      unless admin?
        redirect_to pos_path
      end
    end
  end

  # Optional: Customize post-login path
  def after_sign_in_path_for(resource)
    resource.admin? ? admin_root_path : pos_path
  end

  def render_errors(object)
    respond_to do |format|
      format.html { render :edit, status: :unprocessable_entity }
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace(
          "error_explanation",
          partial: "shared/error_messages",
          locals: { object: object }
        )
      }
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :phone, :address, :profile_image])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :phone, :address, :profile_image])
  end
end
