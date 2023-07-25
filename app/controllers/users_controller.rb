# frozen_string_literal: true

# app/controllers/users_controller.rb
class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, flash: { success: 'User Registration Is Successfully' }
    else
      redirect_to signup_path, flash: { error: 'There was a problem while User Signup' }
    end
  end

  def welcome
    @user = User.where(id: session[:id])
  end

  def username_fetch
    @user = User.where(id: session[:id])
    render json: @user
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
