class Admin::UsersController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path, notice: "User created successfully."
    else
      render :new
    end
  end

  def edit
  end

  def update
    permitted_params = user_params
    if permitted_params[:password].blank? && permitted_params[:password_confirmation].blank?
      permitted_params = permitted_params.except(:password, :password_confirmation)
    end
    if @user.update(permitted_params)
      redirect_to admin_user_path, notice: "User updated."
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: "User deleted."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
  end
end
