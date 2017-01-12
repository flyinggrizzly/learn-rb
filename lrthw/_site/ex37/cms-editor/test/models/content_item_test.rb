require 'test_helper'

# Test ContentItem base model
class ContentItemTest < ActiveSupport::TestCase
  def setup
    # Grab an item from fixtures
    @vice_chancellor_content_item = content_items(:vice_chancellor_content_item)
    @vice_chancellor_content_item.organisation = organisations(:university_of_bath)
  end

  def test_has_user_story
    # Test the fixture data
    assert @vice_chancellor_content_item
    assert_equal 'Web editor', @vice_chancellor_content_item.as_a
    assert_equal 'a page about our Vice Chancellor', @vice_chancellor_content_item.i_need
    assert_equal 'we can have a page about the Vice Chancellor on our website', @vice_chancellor_content_item.so_that

    # Test creating item without user story
    new_item = ContentItem.new
    new_item.title = 'I have no user story'
    new_item.summary = 'This is an item without a user story'
    refute new_item.save
  end

  def test_has_title_summary
    # Test the fixture data
    assert @vice_chancellor_content_item
    assert_equal 'Vice Chancellor', @vice_chancellor_content_item.title
    assert_equal "The Vice Chancellor's page", @vice_chancellor_content_item.summary

    # Test creating item without title or summary
    new_item = ContentItem.new
    new_item.as_a = 'As a developer'
    new_item.i_need = 'a content item without a title, summary and body content'
    new_item.so_that = "I can test that it won't save"
    refute new_item.save
  end

  def test_valid
    assert @vice_chancellor_content_item.valid?, 'VC content item should be valid'
  end

  def test_user_story_invalid
    content_item = content_items(:as_a_user_story_invalid)
    refute content_item.valid?, 'as_a field should be invalid'

    content_item = content_items(:i_need_user_story_invalid)
    refute content_item.valid?, 'i_need field should be invalid'

    content_item = content_items(:so_that_user_story_invalid)
    refute content_item.valid?, 'so_that field should be invalid'
  end

  def test_title_invalid
    content_item = content_items(:title_invalid)
    refute content_item.valid?, 'title field should be invalid'
  end

  def test_summary_invalid
    content_item = content_items(:summary_invalid)
    refute content_item.valid?, 'summary field should be invalid'
  end

  # test the default status is set properly
  def test_default_status
    assert @vice_chancellor_content_item
    assert @vice_chancellor_content_item.draft?
    refute @vice_chancellor_content_item.published?
    assert_equal 'draft', @vice_chancellor_content_item.status
  end

  # test changing status
  def test_change_status
    assert @vice_chancellor_content_item
    assert @vice_chancellor_content_item.draft?
    refute @vice_chancellor_content_item.published?

    # change the status
    @vice_chancellor_content_item.in_review!
    assert @vice_chancellor_content_item.save

    three_day_second_object = content_items(:vice_chancellor_content_item)
    refute three_day_second_object.draft?
    assert three_day_second_object.in_review?
  end

  # test saving and pushing to queue when redis is unavailable
  def test_save_for_publish_no_redis
    assert @vice_chancellor_content_item
    assert @vice_chancellor_content_item.draft?

    # set status ready to publish
    assert @vice_chancellor_content_item.published!
    assert @vice_chancellor_content_item.save # even if queue is missing, should still save
    refute @vice_chancellor_content_item.errors.empty?, 'No error on save - is redis turned on?'
  end

  # test we don't push to queue when saving, not marking for publish
  def test_save_not_publish
    assert @vice_chancellor_content_item
    assert @vice_chancellor_content_item.draft?

    # update the object
    @vice_chancellor_content_item.summary = 'a new summary'
    assert @vice_chancellor_content_item.save # should just work
  end

  def test_last_updated
    @vice_chancellor_content_item.title = 'Updated'
    @vice_chancellor_content_item.save

    assert @vice_chancellor_content_item.updated_at > @vice_chancellor_content_item.created_at
  end

  def test_last_modified_by
    assert @vice_chancellor_content_item.created_by, 'No created by'
    assert @vice_chancellor_content_item.last_modified_by, 'No last modified value'
    assert_equal 'mnskchg', @vice_chancellor_content_item.last_modified_by
  end

  def test_last_modified_by_update
    @vice_chancellor_content_item.updated_by = 'hm401'
    @vice_chancellor_content_item.save

    assert @vice_chancellor_content_item.updated_by, 'No updated by'
    assert @vice_chancellor_content_item.last_modified_by, 'No last modified by after update'
    assert_equal 'hm401', @vice_chancellor_content_item.last_modified_by
  end

  def test_org_association_validation
    content = content_items(:no_organisation_invalid)

    # The fixture data doesn't have an org associated
    refute content.valid?

    content.organisation = organisations(:university_of_bath)
    assert content.valid?
  end

  def test_associated_org_for_content_item
    content = content_items(:marketing_team_content_item)
    refute content.associated_orgs.blank?
    assert content.associated_orgs.include? organisations(:mar_comms)
  end

  def test_url_path_populated
    pp = person_profiles(:url_path_generation_person_profile)
    assert_nil pp.content_item.url_path, 'url_path should be nil for this ContentItem'
    pp.save
    assert_equal '/profiles/person-url-generation-mr-url-path-man', pp.content_item.url_path,
                 'url_path should be populated'
  end

  def test_url_uniqueness
    ci = corporate_informations(:url_uniqueness)
    assert_nil ci.content_item.url_path, 'url_path should be nil for this ContentItem'
    ci.save
    assert_equal '/corporate-information/url-uniqueness-title', ci.content_item.url_path, 'CorporateInformation did not save properly'

    ci = corporate_informations(:url_uniqueness_duplicate)
    assert_nil ci.content_item.url_path, 'url_path should be nil for this ContentItem'
    refute ci.save, 'Item with duplicate url_path should not have saved successfully'
    refute ci.valid?, 'Item with duplicate url_path should not be valid'
  end

  def test_published_content_items_of_type_with_owning_org_scope
    org_id = organisations(:mar_comms).id
    content_type = 'CorporateInformation'

    # Prove there are unpublished content items belonging to this org
    item_count = ContentItem.where(core_data_type: content_type, organisation: org_id).count
    assert_equal 4, item_count

    # Show the scope only returns published content items
    published_item_count = ContentItem.published_content_items_of_type_with_owning_org(content_type, org_id).count
    assert_equal 2, published_item_count
  end

  def test_filter_published_by_org_scope
    # Set up the published state and published_item_json field of the content items
    updated = corporate_informations(:test_filter_published_by_org_scope_updated_corporate_information)
    updated.content_item.published!
    updated.save!
    updated.body_content = 'This has been changed'
    updated.content_item.draft!
    updated.save!

    published = corporate_informations(:test_filter_published_by_org_scope_published_corporate_information)
    published.content_item.published!
    published.save!

    # Get the org id
    org_id = organisations(:test_filter_published_by_org_scope).id

    # Prove there are a known number of content items belonging to this org
    item_count = ContentItem.where(organisation: org_id).count
    assert_equal 3, item_count

    # Prove that the scope returns a smaller number of content items
    published_items = ContentItem.filter_published_by_org(org_id)
    assert_equal 2, published_items.count

    # Prove that published and draft items are included in the returned items
    published_ids = []
    published_items.each do |item|
      published_ids << item.id
    end

    assert_includes published_ids, updated.content_item.id, 'Scope should have returned updated Corporate Information'
    assert_includes published_ids, published.content_item.id,
                    'Scope should have returned published Corporate Information'
  end

  def test_associated_published_by_org
    # Set up the published state and published_item_json field of the content items
    updated = corporate_informations(:test_associated_published_by_org_updated_corporate_information)
    updated.content_item.published!
    updated.save!
    updated.body_content = 'This has been changed'
    updated.content_item.draft!
    updated.save!

    published = corporate_informations(:test_associated_published_by_org_published_corporate_information)
    published.content_item.published!
    published.save!

    # Get the org
    org = organisations(:test_associated_published_by_org_draft)

    # Prove there are a known number of content items are associated to this org
    item_count = org.associated_org_content_items.count
    assert_equal 3, item_count

    # Prove that the method returns a smaller number of content items
    published_items = ContentItem.associated_published_by_org(org.id)
    assert_equal 2, published_items.length

    # Prove that published and draft items are included in the returned items
    published_ids = []
    published_items.each do |item|
      published_ids << item.id
    end

    assert_includes published_ids, updated.content_item.id, 'Method should have returned updated Corporate Information'
    assert_includes published_ids, published.content_item.id,
                    'Method should have returned published Corporate Information'
  end

  def test_associated_published_by_org_no_content
    # Get the org
    org = organisations(:test_associated_published_by_org_no_content_items)

    # Prove that the method successfully returns 0 results without throwing an error
    assert_equal 0, ContentItem.associated_published_by_org(org.id).length
  end

  def test_all_pinnable_by_org
    # Set up the content items
    published_parent = corporate_informations(:test_all_pinnable_by_org_parent_published_corporate_information)
    published_parent.content_item.published!
    published_parent.save!

    updated_child = corporate_informations(:test_all_pinnable_by_org_child_updated_corporate_information)
    updated_child.content_item.published!
    updated_child.save!
    updated_child.body_content = 'This has been changed'
    updated_child.content_item.draft!
    updated_child.save!

    published_child = corporate_informations(:test_all_pinnable_by_org_child_published_corporate_information)
    published_child.content_item.published!
    published_child.save!

    published_associated_child =
      corporate_informations(:test_all_pinnable_by_org_associated_child_published_corporate_information)
    published_associated_child.content_item.published!
    published_associated_child.save!

    # Get the parent org
    org = organisations(:test_all_pinnable_by_org_organisation)

    # Prove the org has a single content item
    assert_equal 1, org.content_items.count

    # Prove the org has a single child group which has 3 content items and 1 associated item
    assert_equal 1, org.groups.count
    assert_equal 3, org.groups.take.content_items.count
    assert_equal 1, org.groups.take.associated_org_content_items.count

    # Prove that the method returns the correct number of content items
    published_items = ContentItem.all_pinnable_by_org(org)
    assert_equal 4, published_items.length

    # Prove that the correct content items are returned
    published_ids = []
    published_items.each do |item|
      published_ids << item.id
    end

    assert_includes published_ids, published_parent.content_item.id,
                    'Method should have returned published item belonging to parent org'
    assert_includes published_ids, updated_child.content_item.id,
                    'Method should have returned updated item belonging to child group'
    assert_includes published_ids, published_child.content_item.id,
                    'Method should have returned published item belonging to child group'
    assert_includes published_ids, published_associated_child.content_item.id,
                    'Method should have returned published item associated with child group'
  end

  def test_all_pinnable_by_org_no_content
    # Get the org
    org = organisations(:test_associated_published_by_org_no_content_items)

    # Prove that the method successfully returns 0 results without throwing an error
    published_items = ContentItem.all_pinnable_by_org(org)
    assert_equal 0, published_items.length
  end

  def test_search_by_cleaned_sql
    evil_sql = 'autocompletes; --'
    assert_equal content_items(:test_search_autocomplete_corporate_information_content_item), ContentItem.search_title_by(evil_sql)[0]
  end

  def test_allow_non_roman_in_search
    cat_name = 'Poznaňská 123; --'
    assert_equal content_items(:test_allow_non_roman_in_search_corporate_information_content_item), ContentItem.search_title_by(cat_name)[0]
  end
end
