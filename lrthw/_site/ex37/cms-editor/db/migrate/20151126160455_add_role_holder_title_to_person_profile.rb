class AddRoleHolderTitleToPersonProfile < ActiveRecord::Migration
  def change
    add_column :person_profiles, :role_holder_title, :string
  end
end
