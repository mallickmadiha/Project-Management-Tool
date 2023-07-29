# frozen_string_literal: true

# app/models/chat.rb
class Chat < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :detail

  validates :message, presence: { message: "Message can't be blank" },
                      length: { maximum: 255, message: 'Message is too long (maximum is 255 characters)' }
end
