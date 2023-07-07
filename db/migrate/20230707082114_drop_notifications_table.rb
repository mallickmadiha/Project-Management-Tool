class DropNotificationsTable < ActiveRecord::Migration[6.1]
  def change
    drop_table :notifications if table_exists?(:notifications)
  end
end
