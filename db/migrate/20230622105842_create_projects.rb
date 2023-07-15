# frozen_string_literal: true

# Migration
class CreateProjects < ActiveRecord::Migration[6.1]
  def change
    create_table :projects do |t|
      t.string :name

      t.timestamps
    end
  end
end
