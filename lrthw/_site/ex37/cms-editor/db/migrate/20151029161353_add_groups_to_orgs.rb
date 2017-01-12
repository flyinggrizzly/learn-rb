class AddGroupsToOrgs < ActiveRecord::Migration
  def change
    add_column :organisations, :parent_organisation_id, :integer
  end
end
