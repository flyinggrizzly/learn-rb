class AddMemberOrderToTeamMemberships < ActiveRecord::Migration
  def change
    add_column :team_memberships, :member_order, :integer
  end
end
