# frozen_string_literal: true

# app/models/user.rb
class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  before_save { self.email = email.downcase }

  validates :username, presence: true, format: { with: /\A\w+\z/, message: 'must be a single word' },
                       uniqueness: { case_sensitive: false, message: 'is already taken for other user' }

  validates :email, presence: true, length: { maximum: 255, message: 'is too long (maximum is 255 characters)' },
                    format: { with: VALID_EMAIL_REGEX, message: 'must be a valid email address' },
                    uniqueness: { case_sensitive: false, message: 'is already taken for other user' }

  validates :password_digest, presence: { message: "can't be blank" }

  has_secure_password

  has_and_belongs_to_many :details
  has_and_belongs_to_many :projects
  has_many :notifications, dependent: :destroy

  has_many :sent_chats, class_name: 'Chat', foreign_key: 'sender_id'
end
