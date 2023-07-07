# frozen_string_literal: true

# app/models/task.rb
class Task < ApplicationRecord
  enum status: %i[Added Done]
  belongs_to :detail
end
