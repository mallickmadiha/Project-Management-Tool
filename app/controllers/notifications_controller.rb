# frozen_string_literal: true

# app/controllers/notifications_controller.rb
class NotificationsController < ApplicationController
  skip_before_action :authenticate_user

  def mark_read
    Notification.mark_as_read_for_user(current_user)
  end
end
