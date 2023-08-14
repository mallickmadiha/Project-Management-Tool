# rubocop:disable all

class AddContraintsToModels < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :username, :string, null: false
    add_index :users, :username, unique: true

    change_column :users, :name, :string, null: false, limit: 255


    add_index :projects, %i[name user_id], unique: true, name: 'index_projects_on_name_and_user'

    add_index :details, %i[title project_id], unique: true, name: 'index_details_on_title_and_project'

    change_column :details, :description, :text, limit: 255

    change_column :chats, :message, :text, limit: 255

  end
end