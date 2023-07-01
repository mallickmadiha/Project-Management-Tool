# frozen_string_literal: true

# app/models/project.rb
class Project < ApplicationRecord
  has_many :details, dependent: :destroy

  has_and_belongs_to_many :users
end
