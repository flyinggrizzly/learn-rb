require 'test_helper'

# Test setting org to content item
class FeatureSetOrganisationTest < Capybara::Rails::TestCase
  def test_editor_in_associated_org_cannot_set_orgs
    # Bypass CAS Single Sign On for testing
    CASClient::Frameworks::Rails::Filter.fake('cteaocso')
    page.set_rack_session(user_authenticated: true)

    # User is an editor, and should only have access to edit this item via Associated Org
    corp_info = corporate_informations(:test_editor_in_associated_org_cannot_set_owning_org_corporate_information)
    visit edit_corporate_information_path(corp_info.id)
    assert page.has_content?('Editing')
    assert page.has_no_select?('corporate_information[content_item_attributes][organisation_id]'),
           'The select field for setting orgs should not be available but is'
  end

  def test_editor_in_owning_org_can_set_org
    # Bypass CAS Single Sign On for testing
    CASClient::Frameworks::Rails::Filter.fake('cteoocso')
    page.set_rack_session(user_authenticated: true)

    corp_info = corporate_informations(:test_editor_in_owning_org_can_set_org_corporate_information)
    visit edit_corporate_information_path(corp_info.id)
    assert page.has_select?('corporate_information[content_item_attributes][organisation_id]'),
           'The select field for setting orgs should be available but is not'
  end

  def test_admin_sees_all
    # Bypass CAS Single Sign On for testing
    CASClient::Frameworks::Rails::Filter.fake('if243')

    # Use webkit driver in Capybara
    Capybara.current_driver = :webkit

    # Block unknown urls
    Capybara.page.driver.block_unknown_urls

    corp = corporate_informations(:test_admin_sees_all_corporate_information)
    visit edit_corporate_information_path(corp.id)

    # Iris belongs to UoB but doesn't belong to Science or the Research group - these should all be listed as an admin.
    assert page.has_select?('corporate_information_content_item_attributes_organisation_id',
                            with_options: ['University of Bath', 'Science - Department', 'Research group - Group']),
           "Not showing admin's options for orgs"
    assert page.has_select?('corporate_information_content_item_attributes_associated_org_ids',
                            with_options: ['University of Bath', 'Science - Department', 'Research group - Group']),
           "Not showing admin's options for associated orgs"
  end

  def test_author_cannot_set_orgs
    # Bypass CAS Single Sign On for testing
    CASClient::Frameworks::Rails::Filter.fake('cms-test-user-with-ass-org-and-group')
    page.set_rack_session(user_authenticated: true)

    # Find the item created by another user who is in the Science Org.
    visit edit_corporate_information_path(ContentItem.find_by_created_by('cms-science-user').core_data_id)

    assert page.has_no_select?('corporate_information[content_item_attributes][organisation_id]'),
           'The select field for setting orgs should not be available but is'
  end

  def test_author_cannot_change_org
    CASClient::Frameworks::Rails::Filter.fake('cms-test-author-cannot-change-org')
    page.set_rack_session(user_authenticated: true)

    # Find the item created by another user
    visit edit_corporate_information_path(ContentItem.find_by_created_by('cms_parent_org_user').core_data_id)

    assert page.has_no_select?('corporate_information_content_item_attributes_organisation_id')
  end

  def test_editor_only_sees_their_orgs
    CASClient::Frameworks::Rails::Filter.fake('cms-test-user-sees-orgs')
    page.set_rack_session(user_authenticated: true)

    corp_info = corporate_informations(:test_editor_only_sees_their_orgs_corporate_information)
    visit edit_corporate_information_path(corp_info)

    assert page.has_select?('corporate_information_content_item_attributes_organisation_id',
                            options: ['Science - Department',
                                      'Org for associating - Department',
                                      'Feature test group - Group']),
           "Not showing author's options for orgs"

    assert page.has_select?('corporate_information_content_item_attributes_associated_org_ids',
                            options: ['Science - Department',
                                      'Org for associating - Department',
                                      'Feature test group - Group']),
           "Not showing author's options for associated orgs"
  end

  def test_associated_editor_cannot_set_org
    CASClient::Frameworks::Rails::Filter.fake('editor-associated-cannot-set')
    page.set_rack_session(user_authenticated: true)

    corp_info = corporate_informations(:test_associated_editor_cannot_set_org_corporate_information)
    visit edit_corporate_information_path(corp_info)

    assert page.has_no_select?('corporate_information_content_item_attributes_organisation_id'),
           'Associated editor should not be able to change org on content item'
  end
end
