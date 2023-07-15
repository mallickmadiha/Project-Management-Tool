# frozen_string_literal: true

# app/models/user.rb
class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  before_save { self.email = email.downcase }

  validates :username, presence: true, format: { with: /\A\w+\z/, message: 'Must be a single word' }

  validates :email, presence: true, length: { maximum: 255, message: 'Email is too long (maximum is 255 characters)' },
                    format: { with: VALID_EMAIL_REGEX, message: 'Must be a valid email address' },
                    uniqueness: { case_sensitive: false }

  validates :password_digest, presence: { message: "Password digest can't be blank" }

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
    )

    user
  end
end
