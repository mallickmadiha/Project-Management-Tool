# frozen_string_literal: true

# Migration
class ChangeColAddForiegnKey < ActiveRecord::Migration[6.1]
  def change
    rename_column :chats, :details_id, :detail_id
    # add_foreign_key :chats, :details
  end
end
