class CreateJoinTableAssociatedOrgsOrganisations < ActiveRecord::Migration
  def change
    create_join_table :associated_orgs, :organisations do |t|
      t.index [:associated_org_id, :organisation_id]
      t.index [:organisation_id, :associated_org_id]
    end
  end
end
