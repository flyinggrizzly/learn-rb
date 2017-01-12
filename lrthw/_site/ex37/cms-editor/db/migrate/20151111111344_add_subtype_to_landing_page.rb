class AddSubtypeToLandingPage < ActiveRecord::Migration
  class OrganisationLandingPage < ActiveRecord::Base; end

  def up
    add_column :organisation_landing_pages, :subtype, :string

    OrganisationLandingPage.find_each do |olp|
      if olp.subtype.blank?
        execute "UPDATE organisation_landing_pages SET subtype = 'organisation' WHERE ID = #{olp.id}"
      end
    end
  end

  def down
    remove_column :organisation_landing_pages, :subtype
    OrganisationLandingPage.reset_column_information
  end
end
