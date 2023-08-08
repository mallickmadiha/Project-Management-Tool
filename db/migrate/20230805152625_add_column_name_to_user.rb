# frozen_string_literal: true

# Migration
class AddColumnNameToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :name, :string, null: false
  end
end
