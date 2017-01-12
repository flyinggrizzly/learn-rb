class AddTeamMembers < ActiveRecord::Migration
  def change
    create_table :team_profiles_person_profiles, id: false do |t|
      t.belongs_to :team_profile, index: true
      t.belongs_to :person_profile, index: true
    end

    change_table :team_profiles do |t|
      t.string :members_with_no_profile
    end
  end
end
