# frozen_string_literal: true

# app/models/project.rb
class Project < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :users
  has_many :details, dependent: :destroy

  validates :name, presence: { message: "Name can't be blank" },
                   length: { maximum: 255, message: 'Name is too long (maximum is 255 characters)' }
  # validates :user_id, presence: { message: "User can't be blank" }
end
