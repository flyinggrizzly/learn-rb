class UpdateContactDetailsTeamProfiles < ActiveRecord::Migration
  def up
    remove_column :team_profiles, :contact_information
    add_column :team_profiles, :contact_name, :string
    add_column :team_profiles, :contact_email, :string
    add_column :team_profiles, :contact_phone, :string
  end

  def down
    remove_column :team_profiles, :contact_name
    remove_column :team_profiles, :contact_email
    remove_column :team_profiles, :contact_phone
    add_column :team_profiles, :contact_information, :string
  end
end
