# frozen_string_literal: true

# app/models/chat.rb
class Chat < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :detail

  validates :message, presence: { message: 'must be present' },
                      length: { in: 5..255, message: 'must be between 5 (min) and 255 (max) characters' },
                      format: { with: /\A[A-Za-z0-9@\s]+\z/,
                                message: 'can only contain the @ character as a special character' }
end
