# frozen_string_literal: true

# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user

  def authenticate_user
    if(session[:type] === 'user') && !session[:id].nil? 
      redirect_to '/projects'
    end
  end

  def current_user
    User.find_by(id: session[:id])
  end
end
