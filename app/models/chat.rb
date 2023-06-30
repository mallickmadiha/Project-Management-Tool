# frozen_string_literal: true

# app/models/chat.rb
class Chat < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :detail
end
