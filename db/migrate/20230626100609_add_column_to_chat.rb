# frozen_string_literal: true

# db/migrate/20230626100609_add_column_to_chat.rb
class AddColumnToChat < ActiveRecord::Migration[6.1]
  def change
    add_column :chats, :details_id, :bigint
  end
end
