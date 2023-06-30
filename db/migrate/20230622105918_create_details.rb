class CreateDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :details do |t|
      t.references :project, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.string :file
      t.integer :status, default: 0
      t.integer :flagType, default: 0
      t.string :uuid

      t.timestamps
    end
  end
end
