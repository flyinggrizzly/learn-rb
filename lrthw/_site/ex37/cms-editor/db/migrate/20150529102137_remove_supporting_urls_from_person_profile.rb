class RemoveSupportingUrlsFromPersonProfile < ActiveRecord::Migration
  def up
    remove_column :person_profiles, :supporting_external_url
  end

  def down
    add_column :person_profiles, :supporting_external_url, :string
  end
end
