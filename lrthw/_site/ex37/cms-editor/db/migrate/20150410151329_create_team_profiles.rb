class CreateTeamProfiles < ActiveRecord::Migration
  def change
    create_table :team_profiles do |t|
      t.text :duties
      t.text :contact_information

      t.timestamps null: false
    end
  end
end
