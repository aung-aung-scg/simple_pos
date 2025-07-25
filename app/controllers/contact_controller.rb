class ContactController < ApplicationController
  def index
    # Optional: Pre-fill form if user is logged in
    @contact = current_user ? { email: current_user.email, name: current_user.name } : {}
  end

  def submit
    name = params[:name]
    email = params[:email]
    message = params[:message]

    # Example: Send email (requires Action Mailer setup)
    # ContactMailer.contact_email(name, email, message).deliver_later

    flash[:success] = "Thank you for your message! We'll get back to you soon."
    redirect_to contact_path
  end
end
