class AddRestrictedToPublications < ActiveRecord::Migration
  def change
    add_column :publications, :restricted, :boolean
  end
end
