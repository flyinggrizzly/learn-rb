class ImproveUrlFormats < ActiveRecord::Migration
  def up
    execute "UPDATE content_items SET url_path = REGEXP_REPLACE(url_path, '^/team-profiles/', '/teams/') WHERE core_data_type = 'TeamProfile'"
    execute "UPDATE content_items SET url_path = REGEXP_REPLACE(url_path, '^/service-starts/', '/services/') WHERE core_data_type = 'ServiceStart'"
    execute "UPDATE content_items SET url_path = REGEXP_REPLACE(url_path, '^/person-profiles/', '/profiles/') WHERE core_data_type = 'PersonProfile'"

    execute "UPDATE (SELECT url_path FROM content_items ci, organisation_landing_pages olp WHERE ci.core_data_id = olp.id AND subtype = 'organisation') t SET t.url_path = REGEXP_REPLACE(t.url_path, '^/organisation-landing-pages/', '/departments/')"
    execute "UPDATE (SELECT url_path FROM content_items ci, organisation_landing_pages olp WHERE ci.core_data_id = olp.id AND subtype = 'group') t SET t.url_path = REGEXP_REPLACE(t.url_path, '^/organisation-landing-pages/', '/groups/')"
  end
  def down
    execute "UPDATE content_items SET url_path = REGEXP_REPLACE(url_path, '^/teams/', '/team-profiles/') WHERE core_data_type = 'TeamProfile'"
    execute "UPDATE content_items SET url_path = REGEXP_REPLACE(url_path, '^/services/', '/service-starts/') WHERE core_data_type = 'ServiceStart'"
    execute "UPDATE content_items SET url_path = REGEXP_REPLACE(url_path, '^/profiles/', '/person-profiles/') WHERE core_data_type = 'PersonProfile'"
    execute "UPDATE content_items SET url_path = REGEXP_REPLACE(url_path, '^/(departments|groups)/', '/organisation-landing-pages/') WHERE core_data_type = 'OrganisationLandingPage'"
  end
end
