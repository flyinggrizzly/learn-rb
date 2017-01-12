class AddPermissionsToUser < ActiveRecord::Migration
  def up
    add_column :users, :admin, :boolean, default: false
    add_column :users, :editor, :boolean, default: false
    add_column :users, :author, :boolean, default: false
    add_column :users, :contributor, :boolean, default: false
  end

  def down
    remove_column :users, :admin
    remove_column :users, :editor
    remove_column :users, :author
    remove_column :users, :contributor
  end
end
