# frozen_string_literal: true

# app/controllers/notifications_controller.rb
class NotificationsController < ApplicationController
  skip_before_action :authenticate_user

  def mark_read
    Notification.where(read: false, user_id: current_user.id).update(read: true)
  end
end
