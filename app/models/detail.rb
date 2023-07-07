# frozen_string_literal: true

# app/models/detail.rb
class Detail < ApplicationRecord
  belongs_to :project
  enum status: %i[Started Finished Delivered]
  enum flagType: %i[backFlag icebox currentIteration]

  has_many_attached :file

  has_many :chats, dependent: :destroy

  has_and_belongs_to_many :users

  has_many :tasks, dependent: :destroy
end
