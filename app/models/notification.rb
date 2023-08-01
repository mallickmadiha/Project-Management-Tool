# frozen_string_literal: true

# app/models/notification.rb
class Notification < ApplicationRecord
  belongs_to :user

  validates :message, presence: { message: "Message can't be blank" }

  scope :mark_as_read_for_user, lambda { |user|
    where(read: false, user_id: user.id).update_all(read: true)
  }
  scope :unread_for_user, lambda { |user|
    where(user_id: user.id, read: false)
  }
end
