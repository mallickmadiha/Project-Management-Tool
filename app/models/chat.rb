# frozen_string_literal: true

# app/models/chat.rb
class Chat < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :detail

  # validates :sender_id, presence: { message: "Sender can't be blank" }
  # validates :detail_id, presence: { message: "Detail can't be blank" }
  validates :message, presence: { message: "Message can't be blank" },
                      length: { maximum: 255, message: 'Message is too long (maximum is 255 characters)' }
end
