# Drop the old join table as Team Memberships now exist
class DropTeamProfilesPersonProfiles < ActiveRecord::Migration
  def up
    drop_table :team_profiles_person_profiles
  end

  def down
    create_table :team_profiles_person_profiles, id: false do |t|
      t.belongs_to :team_profile, index: true
      t.belongs_to :person_profile, index: true
    end
  end
end
