# frozen_string_literal: true

# db/migrate/20230626093949_create_action_cable_events.rb
class CreateActionCableEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :action_cable_events do |t|
      t.string :channel, null: false
      t.string :event, null: false
      t.text :data
      t.timestamps
    end
  end
end
