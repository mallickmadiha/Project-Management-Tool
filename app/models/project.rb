# frozen_string_literal: true

# app/models/project.rb
class Project < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :details, dependent: :destroy

  validates :name,
            presence: { message: "can't be blank" },
            length: { in: 5..30, message: 'must be between 5 and 30 characters' },
            uniqueness: { scope: :user_id, case_sensitive: false, message: 'is already taken for this user' },
            format: { with: /\A[a-zA-Z][a-zA-Z0-9_ ]*\z/,
                      message: 'should start with letter & can contain letters, numbers, underscore' }

  scope :ordered_by_id_desc, lambda {
    order(id: :desc)
  }
end
