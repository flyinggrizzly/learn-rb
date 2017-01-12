require 'test_helper'

# Test Corporate Information actions
class FeatureCorporateInformationTest < Capybara::Rails::TestCase
  def setup
    # Bypass CAS Single Sign On for testing
    CASClient::Frameworks::Rails::Filter.fake('if243')

    # Use webkit driver in Capybara
    Capybara.current_driver = :webkit

    # Block unknown urls
    Capybara.page.driver.block_unknown_urls
  end

  def test_add_new_corporate_information
    visit new_corporate_information_path

    assert page.has_content?('New corporate information'), 'Screen for creating a new corporate information not rendered properly'

    assert fill_in('corporate_information_content_item_attributes_as_a', with: 'Testing robot'), "Couldn't set as_a field"
    assert fill_in('corporate_information_content_item_attributes_i_need', with: 'to create a corporate information'), "Couldn't set i_need field"
    assert fill_in('corporate_information_content_item_attributes_so_that', with: 'I can test whether the form is ok'), "Couldn't set so_that field"
    assert fill_in('corporate_information_content_item_attributes_title', with: 'Brand new corporate information'), "Couldn't set title field"
    assert fill_in('corporate_information_content_item_attributes_summary', with: 'blah'), "Couldn't set summary field"

    assert choose('corporate_information_subtype_factsheet'), 'Could not choose factsheet subtype'
    assert fill_in('corporate_information_body_content', with: 'Blah blah blah'), "Couldn't fill in body content"

    assert choose('corporate_information_call_to_action_type_none'), 'Could not choose url CTA type'
    assert assert fill_in('corporate_information_call_to_action_reason', with: 'Blah blah blah'), "Couldn't fill in no CTA reason"

    assert click_button(I18n.t('shared.status_buttons.save_close'))

    assert_equal root_path, page.current_path
    assert page.has_content?(I18n.t('action_messages.new_save')), 'Saving did not complete properly'
  end

  def test_delete_corporate_information
    visit delete_path
    assert page.has_content?('For test deletion corporate information'), 'Corporate information to be deleted is missing'

    content_item_id = content_items(:for_test_deletion_corporate_information_content_item).id
    corporate_information_id = corporate_informations(:for_test_deletion_corporate_information).id

    # Check all parts of the content item exist
    refute_nil ContentItem.find(content_item_id)
    refute_nil CorporateInformation.find(corporate_information_id)

    # Delete the content item
    assert find("#item-#{content_item_id} td form input").click
    assert_equal delete_path, page.current_path

    assert page.has_no_content?('For test deletion corporate information'), 'Corporate information not deleted'

    # Check all parts are gone
    assert_raise(ActiveRecord::RecordNotFound) { ContentItem.find(content_item_id) }
    assert_raise(ActiveRecord::RecordNotFound) { CorporateInformation.find(corporate_information_id) }
  end

  def test_status_does_not_change_on_validation_error
    corp_info = corporate_informations(:test_status_does_not_change_on_validation_error_corporate_information)
    visit edit_corporate_information_path(corp_info.id)

    assert page.has_content?('Draft.'), "Page doesn't say that status is draft"
    assert choose('corporate_information_call_to_action_type_url'), 'Could not choose url CTA type'
    assert assert fill_in('corporate_information_call_to_action_content', with: 'Blah blah blah'), "Couldn't fill in Call to Action URL"
    assert click_button(I18n.t('shared.status_buttons.publish'))

    assert page.has_no_content?('Published.'), "Page status should not say it's now published!"
    assert page.has_content?('Draft.'), "Page doesn't say that status is draft"
  end

  def test_should_have_preview_link
    corp_info = corporate_informations(:test_should_have_preview_link_corporate_information)
    visit edit_corporate_information_path(corp_info.id)

    assert page.has_content?('In review.'), "Page doesn't say that status is in review"
    assert page.has_link?('View preview page'), "Page doesn't have link to preview"
    assert_equal URI.join(Rails.configuration.x.preview_url, corp_info.content_item.url_path).to_s, page.find_link('View preview page')[:href]
  end

  def test_should_have_published_link
    corp_info = corporate_informations(:test_should_have_published_link_corporate_information)
    visit edit_corporate_information_path(corp_info.id)

    assert page.has_content?('Published.'), "Page doesn't say that status is published"
    assert page.has_link?('View published page'), "Page doesn't say the link for the live page"
    assert_equal Rails.configuration.x.published_url + corp_info.published_version.content_item.url_path.to_s, page.find_link('View published page')[:href]
  end

  def test_should_not_have_preview_links
    corp_info = corporate_informations(:test_should_not_have_preview_links_corporate_information)
    visit edit_corporate_information_path(corp_info.id)

    assert page.has_content?('Draft.'), "Page doesn't say that status is in draft."
    assert page.has_no_link?('View live page'), "Page has the link for the live page when it shouldn't"
    assert page.has_no_link?('View preview page'), "Page has the link for the preview page when it shouldn't"
  end
end
