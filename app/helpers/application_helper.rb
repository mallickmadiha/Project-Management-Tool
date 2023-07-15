# frozen_string_literal: true

# app/helpers/application_helper.rb
module ApplicationHelper
  def current_user
    if !session[:id].nil? && session[:type] == 'user'
      @current_user ||= User.find(session[:id])
    else
      @current_user = nil
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def error_messages(object, field_name)
    return unless object.errors.any?
    return if object.errors.messages[field_name].blank?

    object.errors.messages[field_name].join(', ')
  end
end
