# frozen_string_literal: true

# db/migrate/20230626100643_change_foriengn_key_detail_chat.rb
class ChangeForiengnKeyDetailChat < ActiveRecord::Migration[6.1]
  def change
    add_foreign_key :chats, :details, column: :details_id
  end
end
