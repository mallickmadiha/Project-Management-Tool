# frozen_string_literal: true

# Migration
class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.string :message, null: false
      t.references :user, foreign_key: true, null: false
      t.boolean :read, default: false
    end
  end
end
