# Copy team profiles and person profiles to create team memberships
class CopyTeamProfilesPersonProfiles < ActiveRecord::Migration
  class PersonProfile < ActiveRecord::Base
    has_and_belongs_to_many :team_profiles, join_table: 'team_profiles_person_profiles'
    has_many :team_memberships
    has_many :team_profiles_tmp, through: :team_memberships, source: :team_profile
  end
  class TeamProfile < ActiveRecord::Base
    has_and_belongs_to_many :person_profiles, join_table: 'team_profiles_person_profiles'
    has_many :team_memberships
    has_many :person_profiles_tmp, through: :team_memberships, source: :person_profile
  end
  class TeamMembership < ActiveRecord::Base
    belongs_to :team_profile
    belongs_to :person_profile
  end

  def up
    TeamProfile.find_each do |team_profile|
      team_profile.person_profiles_tmp = team_profile.person_profiles
    end
  end

  def down
  end
end
