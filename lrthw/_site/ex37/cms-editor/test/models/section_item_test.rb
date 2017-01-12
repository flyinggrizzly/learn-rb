require "test_helper"

class SectionItemTest < ActiveSupport::TestCase

  def section_item
    @section_item ||= SectionItem.new
  end

  def test_valid
    assert section_item.valid?
  end

end
