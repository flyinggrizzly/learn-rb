require "test_helper"

class SectionTest < ActiveSupport::TestCase
  def test_section_valid
    assert sections(:text_limit_guide_section).valid?, "Max lengths should be valid"
  end

  def test_invalid_section
    refute sections(:invalid_section).valid?, "Missing title and body from section should be invalid"
  end
end
