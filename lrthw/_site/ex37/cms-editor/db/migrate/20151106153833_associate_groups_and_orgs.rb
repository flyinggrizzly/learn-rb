class AssociateGroupsAndOrgs < ActiveRecord::Migration
  def change
    create_table :associated_orgs_groups, id: false do |t|
      t.belongs_to :organisation, index: true
      t.belongs_to :group, index: true
    end
  end
end
