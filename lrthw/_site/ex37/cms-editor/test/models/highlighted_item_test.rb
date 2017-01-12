require 'test_helper'

class HighlightedItemTest < ActiveSupport::TestCase
  def test_valid
    assert highlighted_items(:valid_highlighted_item).valid?, 'Should have passed validation'
  end

  def test_invalid
    refute highlighted_items(:invalid_item_highlighted_item).valid?, 'Should not have passed validation'
    refute highlighted_items(:missing_item_highlighted_item).valid?, 'Should not have passed validation'
    refute highlighted_items(:invalid_item_type_highlighted_item).valid?, 'Should not have passed validation'
    refute highlighted_items(:missing_item_type_highlighted_item).valid?, 'Should not have passed validation'

    # Database field for item_order is integer, so can't load a string directly from fixtures - set manually
    hi = highlighted_items(:invalid_order_highlighted_item)
    hi.item_order = 'invalid'
    refute hi.valid?, 'Should not have passed validation'

    refute highlighted_items(:missing_order_highlighted_item).valid?, 'Should not have passed validation'
  end

  def test_order
    olp = organisation_landing_pages(:test_highlighted_items_order_organisation_landing_page)
    assert_equal 6, olp.highlighted_campaigns.size

    # For each check index = item_order
    olp.highlighted_campaigns.each_with_index do |item, index|
      assert_equal index, item.item_order
    end
  end
end
