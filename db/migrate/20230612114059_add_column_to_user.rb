# frozen_string_literal: true

# Migration
class AddColumnToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :uid, :string
    add_column :users, :provider, :string
  end
end
