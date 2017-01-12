class RemoveCommunityFieldsFromPersonProfile < ActiveRecord::Migration
  def change
    remove_column :person_profiles, :professional_associations, :text
    remove_column :person_profiles, :community_associations, :text
  end
end
