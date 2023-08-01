# frozen_string_literal: true

require 'httparty'

# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  include SessionsHelper
  skip_before_action :authenticate_user, only: %i[destroy]

  def new; end

  def create
    @user = User.new
    user = find_user_by_email(params[:email])
    if valid_authentication?(user, params[:password])
      user_session_set(user)
      redirect_to_projects_path_with_success_flash
    else
      redirect_to root_path, flash: { error: 'There was a problem while logging in, Invalid Email or Password' }
    end
  end

  def destroy
    session[:id] = nil
    session[:access_token] = nil
    redirect_to root_path
  end

  def omniauth
    user = User.find_by_email(request.env['omniauth.auth'][:info][:email])
    process_user(user)
  end
end
