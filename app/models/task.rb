# frozen_string_literal: true

# app/models/task.rb
class Task < ApplicationRecord
  enum status: %i[Added Done]

  belongs_to :detail

  validates :name, presence: { message: "can't be blank" },
                   length: { in: 5..255, message: 'must be between 5 and 255 characters' },
                   format: { with: /\A[a-zA-Z][a-zA-Z0-9_ ]*\z/,
                             message: 'should start with letter & can contain letters, numbers, underscore' }
end
