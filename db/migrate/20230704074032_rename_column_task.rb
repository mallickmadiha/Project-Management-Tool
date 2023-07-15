# frozen_string_literal: true

# Migration
class RenameColumnTask < ActiveRecord::Migration[6.1]
  def change
    rename_column :tasks, :details_id, :detail_id
  end
end
