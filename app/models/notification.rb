# frozen_string_literal: true

# app/models/notification.rb
class Notification < ApplicationRecord
  belongs_to :user

  validates :message, presence: { message: "Message can't be blank" }
  validates :user_id, presence: { message: "User can't be blank" }
end
