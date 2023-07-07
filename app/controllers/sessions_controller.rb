# frozen_string_literal: true

require 'httparty'

# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  skip_before_action :authenticate_user, only: [:destroy]

  def new; end

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      session[:id] = user.id
      session[:type] = 'user'
      cookies.signed[:user_id] = user.id
      redirect_to '/projects'
    else
      redirect_to '/'
    end
  end

  def destroy
    session[:id] = nil
    session[:type] = nil

    # for revoking access token
    session[:access_token] = nil

    redirect_to '/'
  end

  def omniauth
    user = User.find_or_create_by(uid: request.env['omniauth.auth'][:uid],
                                  provider: request.env['omniauth.auth'][:provider]) do |u|
      u.username = request.env['omniauth.auth'][:info][:first_name]
      u.email = request.env['omniauth.auth'][:info][:email]
      u.password_digest = SecureRandom.hex(15)
    end
    if user.valid?
      session[:id] = user.id
      session[:type] = 'user'
      cookies.signed[:user_id] = user.id
      # for revoking access token
      session[:access_token] = request.env['omniauth.auth'][:credentials][:token]
      revoke_token(session[:access_token]) if session[:access_token].present?

      redirect_to projects_path
    else
      redirect_to login_path
    end
  end

  # for revoking access token
  def revoke_token(token)
    response = HTTParty.post('https://accounts.google.com/o/oauth2/revoke',
                             query: { token: },
                             headers: { 'Content-Type' => 'application/x-www-form-urlencoded' })
    return unless response.code == 200
    # Success revoking token
  end
end
