class AddUniquenessToOrgNames < ActiveRecord::Migration
  def change
    add_index :organisations, :name, unique: true
    add_index :associated_orgs, :name, unique: true
  end
end
