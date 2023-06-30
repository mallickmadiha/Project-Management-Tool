# frozen_string_literal: true

# db/migrate/20230626093828_create_chats.rb
class CreateChats < ActiveRecord::Migration[6.1]
  def change
    create_table :chats do |t|
      t.references :sender, null: false, foreign_key: { to_table: :details }
      t.text :message
      t.text :mentioned_user_ids

      t.timestamps
    end
  end
end
