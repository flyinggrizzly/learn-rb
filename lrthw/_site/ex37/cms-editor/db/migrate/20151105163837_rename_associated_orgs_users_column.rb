class RenameAssociatedOrgsUsersColumn < ActiveRecord::Migration
  def change
    change_table :associated_orgs_users do |t|
      t.rename :associated_org_id, :organisation_id
    end
  end
end
