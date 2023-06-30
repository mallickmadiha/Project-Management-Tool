# frozen_string_literal: true

# db/migrate/20230626100300_change_foriengn_key_chat.rb
class ChangeForiengnKeyChat < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :chats, :details
    add_foreign_key :chats, :users, column: :sender_id
  end
end
