# frozen_string_literal: true

# Migration
class AddValidationsToModels < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :username, :string, null: false
    change_column :users, :email, :string, null: false, limit: 255
    add_index :users, :email, unique: true
    change_column :users, :password_digest, :string, null: false

    change_column :notifications, :message, :string, null: false

    change_column :details, :title, :string, null: false, limit: 30
    change_column :details, :description, :text, null: false

    change_column :chats, :message, :text, null: false

    change_column :projects, :name, :string, null: false, limit: 30

    change_column :tasks, :name, :string, null: false, limit: 255
  end
end
