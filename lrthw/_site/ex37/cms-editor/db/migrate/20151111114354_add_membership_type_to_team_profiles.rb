class AddMembershipTypeToTeamProfiles < ActiveRecord::Migration
  def change
    add_column :team_profiles, :membership_type, :string
  end
end
