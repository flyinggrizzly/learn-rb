require 'test_helper'
require 'content_type_list_service'

class OrganisationLandingPageTest < ActiveSupport::TestCase
  def setup
    @organisation_landing_page = organisation_landing_pages(:maximum_length_values_on_campus_organisation_landing_page)
  end

  def test_can_have_publishing_metadata_hooks_concern_included
    assert_kind_of OrganisationLandingPage, @organisation_landing_page, 'Should be an OrganisationLandingPage'
    assert OrganisationLandingPage.method_defined?(:published_version),
           'OrganisationLandingPage should include CanHavePublishingMetadataHooks'
    assert defined?(@organisation_landing_page.last_published_version),
           'OrganisationLandingPage should have a last_published_version field'
  end

  def test_saved_url_path_for_funnelback
    # Change the title and publish so we can check that the new generated url_path is
    # saved correctly in the published_item_json
    olp = organisation_landing_pages(:test_saved_url_path_for_funnelback)
    olp.content_item.title = 'New title - padded to the maximum length'.ljust(100, ' padding')
    olp.content_item.published!
    olp.save!
    assert_equal olp.content_item.url_path,
                 JSON.parse(olp.content_item.published_item_json)['url_path'],
                 'New url_path not saved in published_item_json'
  end

  def test_maximum_length_values_on_campus_organisation_landing_page
    assert @organisation_landing_page.valid?, 'Landing Page should have been valid'
  end

  def test_maximum_length_values_off_campus_organisation_landing_page
    assert organisation_landing_pages(:maximum_length_values_off_campus_organisation_landing_page).valid?,
           'Landing Page should have been valid'
  end

  def test_missing_on_off_campus
    refute organisation_landing_pages(:missing_on_off_campus_organisation_landing_page).valid?,
           'on_off_campus should be required'
  end

  def test_missing_about
    refute organisation_landing_pages(:missing_about_organisation_landing_page).valid?,
           'about should be required'
  end

  def test_on_campus_validation
    refute organisation_landing_pages(:missing_building_organisation_landing_page).valid?,
           'Landing Page should have failed validation'
  end

  def test_off_campus_validation
    refute organisation_landing_pages(:missing_address_1_organisation_landing_page).valid?,
           'Landing Page should have failed validation'
    refute organisation_landing_pages(:missing_town_organisation_landing_page).valid?,
           'Landing Page should have failed validation'
    refute organisation_landing_pages(:missing_postcode_organisation_landing_page).valid?,
           'Landing Page should have failed validation'
    refute organisation_landing_pages(:missing_country_organisation_landing_page).valid?,
           'Landing Page should have failed validation'
  end

  def test_email_validation
    refute organisation_landing_pages(:invalid_email_organisation_landing_page).valid?,
           'Landing Page should have failed validation'
  end

  def test_phone_validation
    refute organisation_landing_pages(:invalid_phone_organisation_landing_page).valid?,
           'Landing Page should have failed validation'
  end

  def test_content_list_validation
    olp = organisation_landing_pages(:test_content_list_validation)
    refute olp.valid?, 'Organisation landing page should not have been valid'
  end

  def test_max_highlighted_item_count
    ContentTypeListService.without_landing_pages.each do |type|
      # Fetch the landing page for the content type
      olp = organisation_landing_pages("test_max_highlighted_#{type.underscore}_count_organisation_landing_page")
      assert olp.valid?, "Should be valid in preparation for testing #{type}"

      # Add 6 highlighted items and check it is still valid
      6.times do |i|
        olp.send("highlighted_#{type.underscore.pluralize}") << HighlightedItem.create(item: "10_00#{i}".to_i, item_type: type, item_order: i)
      end
      assert_equal 6, olp.send("highlighted_#{type.underscore.pluralize}").size
      assert olp.valid?, "Should be valid after adding 6 #{type.pluralize}"

      # Add a 7th highlighted item and check it is now invalid
      olp.send("highlighted_#{type.underscore.pluralize}") << HighlightedItem.create(item: 10_007, item_type: type, item_order: 7)
      assert_equal 7, olp.send("highlighted_#{type.underscore.pluralize}").size
      refute olp.valid?, "Should not be valid after adding 7 #{type.pluralize}"
    end
  end

  def test_output_attributes
    olp = organisation_landing_pages(:featured_item_organisation_landing_page)
    assert olp.valid?, 'Landing Page should have been valid'

    case_study = case_studies(:featured_case_study)
    assert case_study.valid?, 'Case study should have been valid'

    olp.featured_item_1 = case_study.content_item.id
    olp.content_item.published!
    olp.content_item.save

    output = olp.output_attributes
    refute output[:featured_item_1].blank?, 'Org landing page should have a featured item 1'
    assert output[:featured_item_1].to_json.include?('Featured case study'), 'Featured item 1 should include title'
    assert output[:featured_item_1].to_json.include?('Here are some words'), 'Featured item 1 should include summary'
  end

  def test_output_for_preview
    # Fetch the draft
    org_landing_page  = organisation_landing_pages(:test_org_landing_page_output_for_preview)
    refute_nil org_landing_page

    # Publish it to ensure we trigger Papertrail
    org_landing_page.content_item.status = ContentItem.statuses[:published]
    org_landing_page.save!

    # Check there's a published_version
    refute org_landing_page.published_version.blank?
    assert_equal org_landing_page.published_version, org_landing_page
    assert_equal org_landing_page.output_attributes['about'], org_landing_page.about

    # Change values and set For Review
    refute_nil org_landing_page.content_item
    org_landing_page.content_item.summary = 'Summary after preview'
    org_landing_page.about = 'This is what I say AFTER Review'
    org_landing_page.content_item.status = ContentItem.statuses[:review]
    org_landing_page.save

    # Check that output_attributes isn't the same as last published version attributes
    refute org_landing_page.output_attributes.blank?
    assert_equal org_landing_page.about, org_landing_page.output_attributes['about']
    refute_equal org_landing_page.versions[org_landing_page.last_published_version].reify(has_one: true, has_many: true).about,
                 org_landing_page.output_attributes['about']
  end

  def test_landing_page_url
    olp = organisation_landing_pages(:test_landing_page_url_landing_page)
    olp.save # to trigger populating the url_path
    olp_url = OrganisationLandingPage.landing_page_url_for_org(organisations(:mar_comms))
    refute_nil olp_url
    assert_equal '/departments/whats-my-landing-page-url', olp_url
  end

  def test_org_without_olp_should_have_no_landing_page_url
    olp_url = OrganisationLandingPage.landing_page_url_for_org(organisations(:org_without_landing_page))
    assert_nil olp_url
  end

  def test_null_last_published_version_should_not_throw_error
    # Get olp, ensure status is draft and last_published_version is 'null'
    olp = organisation_landing_pages(:test_null_last_published_version_should_not_throw_error)

    assert_equal 'draft', olp.content_item.status
    assert_nil olp.last_published_version

    url = OrganisationLandingPage.landing_page_url_for_org(organisations(:org_with_landing_page_that_has_no_last_published_ver))
    assert_nil url
  end

  def test_groups_in_output
    # Generate URL for one of the group that has a landing page
    glp = organisation_landing_pages(:landing_page_for_group_in_first_group_for_org_landing_page)
    glp.save
    glp_item = content_items(:landing_page_for_group_in_first_group_for_org_landing_page_content_item)
    glp_item.status = 3
    glp_item.save

    olp = organisation_landing_pages(:test_groups_in_output)
    refute_nil olp.output_attributes[:content_list_items]
    assert_includes olp.output_attributes[:content_list_items],
                    'title' => 'First group for landing page', 'url' => glp_item.url_path
    assert_includes olp.output_attributes[:content_list_items],
                    'title' => 'Second group for landing page', 'url' => nil
  end

  def test_content_list_locations
    # Get org landing page which has location content items
    olp = organisation_landing_pages(:test_content_list_locations)

    # Get the location titles and urls for checking
    loc_1 = locations(:test_one_for_landing_page_location)
    loc_1.content_item.published!
    loc_1.save # Generate the url_path
    loc_2 = locations(:test_two_for_landing_page_location)
    loc_2.content_item.published!
    loc_2.save # Generate the url_path

    # Check that they are in the output
    refute_nil olp.output_attributes[:content_list_items]
    assert_includes olp.output_attributes[:content_list_items], 'title' => loc_1.content_item.title,
                                                                'url' => loc_1.content_item.url_path
    assert_includes olp.output_attributes[:content_list_items], 'title' => loc_2.content_item.title,
                                                                'url' => loc_2.content_item.url_path
  end

  def test_no_content_list
    # Test for when we have a content_list chosen but no items of that type for this org
    olp = organisation_landing_pages(:test_no_content_list)
    assert_nil olp.output_attributes[:content_list_items]
  end
end
