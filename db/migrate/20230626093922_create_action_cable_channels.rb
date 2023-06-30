# frozen_string_literal: true

# db/migrate/20230626093922_create_action_cable_channels.rb
class CreateActionCableChannels < ActiveRecord::Migration[6.1]
  def change
    create_table :action_cable_channels do |t|
      t.string :channel, null: false
      t.string :broadcasting, null: false
      t.timestamps
    end
  end
end
