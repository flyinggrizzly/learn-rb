require 'test_helper'

class CollectionSectionTest < ActiveSupport::TestCase
  def test_valid
    assert collection_sections(:maximum_length_values_collection_section).valid?,
           'Maximum lengths should have been valid - has someone reduced a length?'
  end

  def test_missing_title
    refute collection_sections(:missing_title_collection_section).valid?, 'title should be required'
  end

  def test_missing_summary
    refute collection_sections(:missing_summary_collection_section).valid?, 'summary should be required'
  end

  def test_missing_section_item
    refute collection_sections(:missing_section_item_collection_section).valid?, 'section_item should be required'
  end
end
