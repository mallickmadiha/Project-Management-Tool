class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :name, null: false
      t.integer :status, default: 0
      t.references :details, foreign_key: true
      t.timestamps
    end
  end
end
