class DropAssociatedOrgEntity < ActiveRecord::Migration
  def up
    drop_join_table :associated_orgs, :organisations
    drop_table :associated_orgs
  end

  def down
    create_table :associated_orgs do |t|
      t.string :name
      t.string :contact_information

      t.timestamps null: false
    end

    create_join_table :associated_orgs, :organisations do |t|
      t.index [:associated_org_id, :organisation_id]
      t.index [:organisation_id, :associated_org_id]
    end
  end
end
