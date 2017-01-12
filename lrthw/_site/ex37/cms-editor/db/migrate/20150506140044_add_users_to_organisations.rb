class AddUsersToOrganisations < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.belongs_to :organisation, index: true
    end
  end
end
