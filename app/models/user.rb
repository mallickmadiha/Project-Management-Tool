# frozen_string_literal: true

# app/models/user.rb
class User < ApplicationRecord
  has_secure_password

  VALID_EMAIL_REGEX = /\A[a-zA-Z0-9][\w+\-.]*@[a-zA-Z0-9][a-zA-Z0-9\-.]*\.[a-zA-Z]+\z/
  before_save { self.email = email.downcase }

  validates :username, presence: true,
                       uniqueness: { case_sensitive: false, message: 'is already taken for other user' }

  validate :validate_username_format

  validates :name, presence: { message: "can't be blank" },
                   length: { in: 5..255, message: 'must be between 5 and 255 characters' },
                   format: { with: /\A[A-Za-z ]+\z/,
                             message: 'can contain only alphabets' }

  validates :email, presence: true, length: { maximum: 255, message: 'is too long (maximum is 255 characters)' },
                    format: { with: VALID_EMAIL_REGEX, message: 'must be a valid email address' },
                    uniqueness: { case_sensitive: false, message: 'is already taken for other user' }

  validate :custom_password_validation, on: %i[create update]

  has_and_belongs_to_many :details
  has_and_belongs_to_many :projects
  has_many :notifications, dependent: :destroy

  has_many :sent_chats, class_name: 'Chat', foreign_key: 'sender_id'

  scope :mentioned_users, lambda { |mentioned_usernames|
                            where(username: mentioned_usernames)
                          }
  scope :not_in_project, lambda { |project|
    where.not(id: project.users.pluck(:id))
  }
  scope :with_username_query, lambda { |project, query|
    project.users.where('username LIKE ?', "%#{query}%")
  }

  def validate_username_format
    return if username.blank?

    if username.match?(/\s/)
      errors.add(:username, 'must be a single word (no spaces allowed)')
      return
    end
    return if username.match?(/\A[A-Za-z0-9]+\z/)

    errors.add(:username, 'must contain only alphabets and numbers (no special characters or spaces)')
  end

  def custom_password_validation
    return unless password.present?

    unless password.match?(/[A-Z]/) && password.match?(/[a-z]/) &&
           password.match?(/[!@#$%^&*()\-_=+{};:,<.>]/) && password.length >= 8
      errors.add(:password,
                 'must be at least 8 characters long and include at least one uppercase letter,
                 one lowercase letter, and one special character')
    end
  end
end
