class NotificationsController < ApplicationController
  def mark_read
    Notification.where(read: false, user_id: current_user.id).update(read: true)
  end
end
