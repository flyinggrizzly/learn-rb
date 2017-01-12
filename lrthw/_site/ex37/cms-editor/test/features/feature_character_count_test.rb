require 'test_helper'

# Test Content Items actions
class FeatureCharacterCountTest < Capybara::Rails::TestCase
  def setup
    # Bypass CAS Single Sign On for testing
    CASClient::Frameworks::Rails::Filter.fake('if243')

    # Use webkit driver in Capybara
    Capybara.current_driver = :webkit

    # Block unknown urls
    Capybara.page.driver.block_unknown_urls
  end

  def test_character_count
    visit new_team_profile_path

    # Check that there are 2 counter boxes displayed
    assert page.find('#team_profile_content_item_attributes_title_counter').visible?,
           'Page does not have a title character count box'
    assert page.find('#team_profile_content_item_attributes_summary_counter').visible?,
           'Page does not have a summary character count box'

    # Check that the counter is at zero and has the correct maximum
    assert page.has_content?('0 of ' + I18n.t('shared.content_item.title_maxlength').to_s + ' characters used'),
           'Character count or maxlength is wrong'

    # Check that typing in the input field increments the counter
    assert fill_in('team_profile_content_item_attributes_title', with: 'This text is 31 characters long'),
           "Couldn't set title text"
    assert page.has_content?('31 of ' + I18n.t('shared.content_item.title_maxlength').to_s + ' characters used'),
           'Character count or maxlength is wrong'

    # Check that the over-limit class is applied when too much text is input
    assert fill_in('team_profile_content_item_attributes_title',
                   with: 'This text is too long This text is too long This text is too long '),
           "Couldn't set title text"
    assert page.has_css?('#team_profile_content_item_attributes_title_counter.over-limit'),
           "Character count box doesn't have over-limit class"
  end
end
