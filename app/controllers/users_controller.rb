class UsersController < ApplicationController
  # before_action :authenticate_user!

  # def index
  #   @users = User.all
  # end

  # def edit
  #   @user = User.find(params[:id])
  # end

  # def update
  #   @user = User.find(params[:id])
  #   if @user.update(user_params)
  #     redirect_to users_path, notice: "User updated successfully."
  #   else
  #     render :edit
  #   end
  # end

  # def destroy
  #   @user = User.find(params[:id])
  #   @user.destroy
  #   redirect_to users_path, notice: "User deleted successfully."
  # end

  # private

  # def ensure_super_admin!
  #   redirect_to root_path, alert: "Unauthorized access." unless current_user.super_admin?
  # end

  # def user_params
  #   params.require(:user).permit(:email, :password, :password_confirmation, :phone, :avatar)
  # end
end