# frozen_string_literal: true

# app/controllers/users_controller.rb
class UsersController < ApplicationController
  skip_before_action :authenticate_user

  def new
    @user = User.new
  end

  def show
    @user = User.find_by(username: params[:username])
    return render 'partials/_404' if @user.nil?
  end

  def edit
    @user = User.find(params[:id])
    return render 'partials/_404' if @user.nil?
    return render 'partials/_404' if @user != current_user
  end

  def update
    @user = User.find(params[:id])

    if update_params[:new_password].present? || update_params[:new_password_confirmation].present?
      update_user_with_password
    else
      update_user_profile
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, flash: { success: 'User Registration Is Successfully' }
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :name)
  end

  def update_params
    params.require(:user).permit(:name, :username, :email, :current_password, :password, :password_confirmation)
  end

  def update_user_profile
    if @user.update(update_params.except(:current_password, :new_password, :new_password_confirmation))
      redirect_to edit_user_path(@user), flash: { success: 'Profile successfully updated.' }
    else
      redirect_to edit_user_path(@user), flash: { error: @user.errors.full_messages.join(', ') }
    end
  end

  def update_user_with_password
    if @user.update(update_params.except(:current_password))
      redirect_to edit_user_path(@user), flash: { success: 'Profile and password successfully updated.' }
    else
      redirect_to edit_user_path(@user), flash: { error: @user.errors.full_messages.join(', ') }
    end
  end
end
