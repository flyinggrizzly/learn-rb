# Create table for team memberships
class CreateTeamMemberships < ActiveRecord::Migration
  def change
    create_table :team_memberships do |t|
      t.belongs_to :team_profile, null: false, index: true
      t.belongs_to :person_profile, null: false, index: true
    end
    add_foreign_key :team_memberships, :team_profiles
    add_foreign_key :team_memberships, :person_profiles
  end
end
