class NotificationsController < ApplicationController
  skip_before_action :authenticate_user, only: %i[mark_read]
  def mark_read
    Notification.where(read: false, user_id: current_user.id).update(read: true)
  end
end
