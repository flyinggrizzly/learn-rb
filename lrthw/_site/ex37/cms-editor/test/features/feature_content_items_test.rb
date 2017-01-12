require 'test_helper'

# Test Content Items actions
class FeatureContentItemsTest < Capybara::Rails::TestCase
  def setup
    # Bypass CAS Single Sign On for testing
    CASClient::Frameworks::Rails::Filter.fake('if243')

    # Use webkit driver in Capybara
    Capybara.current_driver = :webkit

    # Block unknown urls
    Capybara.page.driver.block_unknown_urls
  end

  def test_display_list_of_items
    visit root_path
    assert page.has_table?('A list of all content currently in the CMS.')
    assert page.has_css?('table.content-items')
    ContentItem.order(updated_at: :desc).limit(30).each do |item|
      selector = "#item-#{item.id}"
      within(selector) do
        assert page.has_content?(item.title)
        assert page.has_content?(item.updated_at.to_formatted_s(:day_month_year_time))
        assert page.has_content?(item.updated_by)
      end
    end
  end

  def test_display_type_and_subtype
    visit root_path
    assert page.has_table?('A list of all content currently in the CMS.')

    # Apply a filter so we know which items will be on page 1
    assert select(organisations(:science).name), "Couldn't select organisation in filter form"
    click_button(I18n.t('content_items.index.filter_submit'))

    # Check we are displaying the subtype when there is one
    within('#item-' + content_items(:item_belonging_to_science_item).id.to_s) do
      assert find('td.item-subtype').has_content?('Factsheet')
    end

    # Check we are displaying the type when there is no subtype
    within('#item-' + content_items(:team_no_members_team_content_item).id.to_s) do
      assert find('td.item-type').has_content?('Team profile')
    end
  end

  def test_content_list_filter
    visit root_path
    assert page.has_text?(I18n.t('content_items.index.heading'))

    # Get number of items in unfiltered list
    total_number_of_all_items = find('span.item-count b:last-child').text.to_i
    assert total_number_of_all_items > 0, 'No items were listed on the content_items index page'

    # Apply a filter
    assert select(organisations(:university_of_bath).name), "Couldn't select organisation in filter form"
    click_button(I18n.t('content_items.index.filter_submit'))

    # Check that there are fewer items than the unfiltered list
    assert page.has_text?(I18n.t('content_items.index.heading'))
    assert find('span.item-count b:last-child').text.to_i < total_number_of_all_items, "Filter didn't work"
  end

  def test_search_autocomplete
    visit root_path
    assert page.has_text?(I18n.t('content_items.index.heading'))

    # Fill in the text box to search for a title
    assert page.fill_in(I18n.t('content_items.index.autocomplete_label'), with: 'autocompletes')
    assert page.has_css?('li.ui-menu-item'), 'Expected to see results listing on page'

    assert first('li.ui-menu-item').click
    assert page.has_text?('Editing corporate information')
  end
end
