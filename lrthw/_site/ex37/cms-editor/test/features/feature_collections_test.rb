require 'test_helper'

# Test Guides actions
class FeatureCollectionsTest < Capybara::Rails::TestCase
  def setup_as_admin
    # Bypass CAS Single Sign On for testing
    CASClient::Frameworks::Rails::Filter.fake('if243')

    # Use webkit driver in Capybara
    Capybara.current_driver = :webkit

    # Block unknown urls
    Capybara.page.driver.block_unknown_urls
  end

  def setup_as_non_admin
    # Bypass CAS Single Sign On for testing
    CASClient::Frameworks::Rails::Filter.fake('rg373')

    # Use webkit driver in Capybara
    Capybara.current_driver = :webkit

    # Block unknown urls
    Capybara.page.driver.block_unknown_urls
  end

  def test_cannot_edit_labels
    setup_as_admin

    visit edit_collection_path(collections(:test_cannot_edit_labels_collection).id)

    assert page.has_content?('Editing collection'), 'Screen for editing collection not rendering properly'
    assert page.has_no_css?('#collection_content_item_attributes_label_ids'),
           'Screen for editing should not allow editing of labels but select select box is being displayed'
    assert page.has_no_css?('#dummy_labels'),
           'Screen for editing should not allow editing of labels but select JS input is being displayed'
  end

  def test_non_admin_cannot_edit
    setup_as_non_admin

    collection = collections(:test_non_admin_cannot_edit_collection)
    visit edit_collection_path(collection)

    assert_includes page.html, I18n.t('shared.content_item_display_only.no_permission_html'),
                    'User should see permission denied message'
    assert page.has_no_field?('collection_content_item_attributes_as_a'),
           'User should not be able to edit content item fields'
    assert page.has_no_field?('collection[content_item_attributes][organisation_id]'),
           'User should not be able to set owning org'

    assert has_no_button?(I18n.t('shared.status_buttons.save_close'))
  end

  def test_add_new_collection
    setup_as_admin

    visit new_collection_path

    assert page.has_content?('New collection'), 'Screen for creating a new collection not rendered properly'

    assert fill_in('collection_content_item_attributes_as_a', with: 'Testing robot'), "Couldn't set as_a field"
    assert fill_in('collection_content_item_attributes_i_need', with: 'To create a collection'),
           "Couldn't set i_need field"
    assert fill_in('collection_content_item_attributes_so_that', with: 'I can test whether the form is ok'),
           "Couldn't set so_that field"
    assert fill_in('collection_content_item_attributes_title', with: 'Brand new collection'), "Couldn't set title field"
    assert fill_in('collection_content_item_attributes_summary', with: 'Summary'), "Couldn't set summary field"

    assert select(labels(:maximum_length_label).name, from: 'dummy_labels')
    click_link('Add label')
    assert page.has_selector?('.repeatable-field-medium', count: 1), 'Label not added to collection'

    assert click_button(I18n.t('shared.status_buttons.save_close'))

    assert_equal root_path, page.current_path
    assert page.has_content?(I18n.t('action_messages.new_save')), 'Saving did not complete properly'
  end

  def test_delete_collection
    setup_as_admin

    visit delete_path
    assert page.has_content?('For test deletion collection'), 'Collection to be deleted is missing'

    content_item_id = content_items(:test_deletion_collection_content_item).id
    collection_id = collections(:test_deletion_collection).id

    # Check all parts of the content item exist
    refute_nil ContentItem.find(content_item_id)
    refute_nil Collection.find(collection_id)

    # Delete the content item
    assert find("#item-#{content_item_id} td form input").click
    assert_equal delete_path, page.current_path

    assert page.has_no_content?('For test deletion collection'), 'Collection not deleted'

    # Check all parts are gone
    assert_raise(ActiveRecord::RecordNotFound) { ContentItem.find(content_item_id) }
    assert_raise(ActiveRecord::RecordNotFound) { Collection.find(collection_id) }
  end

  def test_add_sections_collection
    setup_as_admin

    # Set up item to use as section item
    si = corporate_informations(:test_add_sections_collection_corporate_information)

    # Publish it to generate the published_item_json required for filter_published_by_label
    visit edit_corporate_information_path(corporate_informations(:test_add_sections_collection_corporate_information))
    assert click_button(I18n.t('shared.status_buttons.publish'))
    assert_equal root_path, page.current_path

    # Edit the collection
    visit edit_collection_path(collections(:test_add_sections_collection))

    # Add section text
    assert fill_in('collection_collection_sections_attributes_0_title', with: 'Section title'),
           "Couldn't fill in Section title"
    assert fill_in('collection_collection_sections_attributes_0_summary', with: 'Section summary'),
           "Couldn't fill in Section summary"

    # Add section item
    display_title_type_status = "#{si.content_item.title} (#{si.content_item.core_data_type.underscore.humanize}) \
- #{si.content_item.status.humanize}"
    assert select(display_title_type_status,
                  from: 'collection_collection_sections_attributes_0_section_items_attributes_0_content_item_id'),
           "Couldn't choose an item"
    assert click_button(I18n.t('shared.status_buttons.save_close'))

    assert_equal root_path, page.current_path
    assert page.has_content?(I18n.t('action_messages.new_save')), 'Saving did not complete properly'
  end
end
