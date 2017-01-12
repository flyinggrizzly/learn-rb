class AddContentListToOrganisationLandingPage < ActiveRecord::Migration
  def change
    add_column :organisation_landing_pages, :content_list, :string
  end
end
