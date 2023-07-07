# frozen_string_literal: true

# app/models/user.rb
class User < ApplicationRecord
  validates :username, presence: true, format: { with: /\A\w+\z/, message: 'Should be a single word' }

  has_secure_password

  has_many :projects, dependent: :destroy
  has_many :details, through: :projects
  has_many :notifications, dependent: :destroy

  has_and_belongs_to_many :details
  has_and_belongs_to_many :projects

  has_many :sent_chats, class_name: 'Chat', foreign_key: 'sender_id'

  def self.from_omniauth(auth)
    user = User.find_by(email: auth.info.email)

    user ||= User.create(
      email: auth.info.email,
      username: auth.info.name
      # ... other attributes you want to save from the authentication data
    )

    user
  end
end
