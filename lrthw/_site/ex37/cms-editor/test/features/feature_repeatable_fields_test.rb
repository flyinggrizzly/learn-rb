require 'test_helper'

# Test Content Items actions
class FeatureRepeatableFieldsTest < Capybara::Rails::TestCase
  def setup
    # Bypass CAS Single Sign On for testing
    CASClient::Frameworks::Rails::Filter.fake('if243')

    # Use webkit driver in Capybara
    Capybara.current_driver = :webkit

    # Block unknown urls
    Capybara.page.driver.block_unknown_urls
  end

  def test_add_field
    visit new_person_profile_path

    # Check that there's an add link button
    assert page.has_link?('Add link'), "Page does not have an 'Add link' button"
    assert page.find('a', text: 'Add link').visible?, "Page does not have a visible 'Add link' button"
    assert page.has_css?('.repeatable-field', count: 0), 'Page has .repeatable-field elements. JS probably not loaded.'

    # Check that clicking the 'Add link' button adds new fields
    click_link('Add link')
    assert page.has_css?('.repeatable-field', count: 1), 'New field not added to page'
    click_link('Add link')
    assert page.has_css?('.repeatable-field', count: 2), 'Second new field not added to page'
  end

  def test_remove_field
    vc = PersonProfile.find_by_role_holder_name('Glynis M. Breakwell')
    visit edit_person_profile_path(vc.id)

    # Check that there's a remove button visible on the page
    assert page.find('a.button-secondary.button-inline.negative').visible?,
           "Page does not have a visible 'Remove' button"

    # Check that clicking the remove button removes the field
    click_link('Remove')
    assert page.has_css?('.repeatable-field', count: 0), "Field not removed from page using 'Remove' button"
  end

  def test_blank_fields_with_no_javascript
    # Use rack driver for no JavaScript
    Capybara.current_driver = :rack_test

    # Go to new person profile page and check for 3 blank fields
    visit new_person_profile_path
    assert page.has_css?('.repeatable-field', count: 3),
           "Page doesn't have 3 .repeatable-field elements. JS probably loaded."

    # Go to edit person profile page and check for 3 blank fields
    vc = PersonProfile.find_by_role_holder_name('Glynis M. Breakwell')
    visit edit_person_profile_path(vc.id)
    number_of_exisiting_urls = vc.urls.count
    assert page.has_css?('.repeatable-field', count: (number_of_exisiting_urls + 3)),
           "Page doesn't have 3 blank fields. JS probably loaded."

    # Switch back to webkit driver
    Capybara.current_driver = :webkit
  end
end
