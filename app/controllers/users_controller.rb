# frozen_string_literal: true

# app/controllers/users_controller.rb
class UsersController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:email])
    if params[:password_digest].eql?(params[:password_confirmation])
      if user
        redirect_to '/'
      else
        user_params_new = user_params.except(:password_confirmation)
        user = User.new(user_params_new)
        if user.save
          redirect_to '/'
        else
          redirect_to '/signup'
        end
      end
    else
      redirect_to '/signup'
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
    params.permit(:username, :email, :password_digest, :password_confirmation)
  end
end
