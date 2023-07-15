# frozen_string_literal: true

# app/models/task.rb
class Task < ApplicationRecord
  enum status: %i[Added Done]

  belongs_to :detail

  validates :name, presence: { message: "Name can't be blank" },
                   length: { maximum: 255, message: 'Name is too long (maximum is 255 characters)' }
end
