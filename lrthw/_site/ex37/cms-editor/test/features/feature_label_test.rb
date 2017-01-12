require 'test_helper'

# Test Label functionality on content items
class FeatureLabelTest < Capybara::Rails::TestCase
  def setup
    # Bypass CAS Single Sign On for testing
    CASClient::Frameworks::Rails::Filter.fake('if243')

    # Use webkit driver in Capybara
    Capybara.current_driver = :webkit

    # Block unknown urls
    Capybara.page.driver.block_unknown_urls
  end

  def test_add_label_no_js
    # Use rack driver for no JavaScript
    Capybara.current_driver = :rack_test
    ci = corporate_informations(:test_add_label_no_js_corporate_information)
    visit edit_corporate_information_path(ci.id)

    assert page.has_css?('select#corporate_information_content_item_attributes_label_ids'),
           'Missing select box of Labels'
    assert select(labels(:research_label).name, from: 'corporate_information[content_item_attributes][label_ids][]')

    click_button(I18n.t('shared.status_buttons.save'))

    visit edit_corporate_information_path(ci.id)
    assert page.find('#corporate_information_content_item_attributes_label_ids option',
                     text: labels(:research_label).name).selected?
  end

  def test_add_label
    visit new_team_profile_path

    # Check that there is an 'Add label' button
    assert page.has_link?('Add label'), "Page does not have an 'Add label' button"
    assert page.find('a[data-button="add-label"]').visible?, "Page does not have a visible 'Add label' button"

    # Check that the default select box has been removed
    assert page.has_no_selector?('#team_profile_content_item_attributes_label_ids'),
           'Page has default select box. JS probably not loaded.'

    # Check that selecting a label and clicking the 'Add label' button adds a label
    assert select(labels(:maximum_length_label).name, from: 'dummy_labels')
    click_link('Add label')
    assert page.has_selector?('.repeatable-field-medium', count: 1), 'Label not added to content item'

    # Check that selecting another label and clicking the 'Add label' button adds a label
    assert select(labels(:research_label).name, from: 'dummy_labels')
    click_link('Add label')
    assert page.has_selector?('.repeatable-field-medium', count: 2), 'A second label not added to content item'
  end

  def test_remove_label
    ci = corporate_informations(:test_remove_label_corporate_information)
    visit edit_corporate_information_path(ci.id)

    # Check that there are 2 Remove buttons and 2 repeatable fields on the page
    assert page.has_css?('a[data-button="remove-label"]', count: 2), 'Page does not have 2 remove label buttons'
    assert page.has_css?('.repeatable-field-medium', count: 2), 'Page does not have 2 repeatable fields'

    # Check that clicking the remove button removes the field
    first('a[data-button="remove-label"]').click
    assert page.has_css?('.repeatable-field-medium', count: 1), "Field not removed from page using 'Remove' button"
  end

  def test_remove_then_add_label
    ci = corporate_informations(:test_remove_label_corporate_information)
    visit edit_corporate_information_path(ci)

    # Check that there are 2 Remove buttons and 2 repeatable fields on the page
    assert page.has_css?('a[data-button="remove-label"]', count: 2), 'Page does not have 2 remove label buttons'
    assert page.has_css?('.repeatable-field-medium', count: 2), 'Page does not have 2 repeatable fields'

    # Check that select does not contain first added item
    label = first('.repeatable-field-medium').first('input').value
    assert page.has_no_select?('dummy_labels', with_options: [label]), 'Added label should not be in the select options'

    # Check that clicking the remove button removes the field
    first('a[data-button="remove-label"]').click
    assert page.has_css?('.repeatable-field-medium', count: 1), "Field not removed from page using 'Remove' button"

    # Check it has been added to the select options
    assert page.has_select?('dummy_labels', with_options: [label]), 'Removed label should be in the select options'

    # Add it back to check it has been added correctly
    assert select(label, from: 'dummy_labels')
    click_link('Add label')
    assert page.has_css?('.repeatable-field-medium', count: 2), 'Label not added back to content item'
  end
end
