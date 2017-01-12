class AddSubTypeToTeams < ActiveRecord::Migration
  class TeamProfile < ActiveRecord::Base
  end

  def change
    add_column :team_profiles, :subtype, :string

    TeamProfile.reset_column_information
    TeamProfile.where(subtype: nil).update_all(subtype: 'professional_service_team')
  end
end
