class AddLastPublishedVersionToContentItems < ActiveRecord::Migration
  def up
    add_column :person_profiles, :last_published_version, :integer
    add_column :team_profiles, :last_published_version, :integer
    add_column :events, :last_published_version, :integer
  end

  def down
    remove_column :person_profiles, :last_published_version
    remove_column :team_profiles, :last_published_version
    remove_column :events, :last_published_version
  end
end
