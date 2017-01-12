class ChangeContactInformationToStringInTeamProfile < ActiveRecord::Migration
  def up
    remove_column :team_profiles, :contact_information, :text
    add_column :team_profiles, :contact_information, :string
  end

  def down
    remove_column :team_profiles, :contact_information, :string
    add_column :team_profiles, :contact_information, :text
  end
end
