# frozen_string_literal: true

# app/models/project.rb
class Project < ApplicationRecord
  has_many :details, dependent: :destroy
end
