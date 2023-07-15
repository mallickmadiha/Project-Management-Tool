# frozen_string_literal: true

# Migration
class AddNameToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :username, :string
  end
end
