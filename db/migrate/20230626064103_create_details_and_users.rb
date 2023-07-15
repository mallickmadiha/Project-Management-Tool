# frozen_string_literal: true

# Migration
class CreateDetailsAndUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :details_users, id: false do |t|
      t.belongs_to :detail
      t.belongs_to :user
    end
  end
end
