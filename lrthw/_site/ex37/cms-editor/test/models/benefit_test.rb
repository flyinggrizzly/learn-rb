require 'test_helper'

class BenefitTest < ActiveSupport::TestCase
  def test_cta_concern_included
    assert CaseStudy.include?(CanHaveCallToAction), 'CanHaveCallToAction concern should have been included'
  end

  def test_valid
    assert benefits(:maximum_length_values_benefit).valid?,
           'Maximum lengths should have been valid - has someone reduced a length?'
  end

  def test_missing_description
    refute benefits(:missing_description_benefit).valid?, 'description should be required'
  end

  def test_missing_call_to_action_label
    refute benefits(:missing_call_to_action_label_benefit).valid?, 'call_to_action_label should be required'
  end

  def test_missing_call_to_action_content
    refute benefits(:missing_call_to_action_content_benefit).valid?, 'call_to_action_content should be required'
  end

  def test_missing_image_alt
    refute benefits(:missing_image_alt_benefit).valid?, 'image_alt should be required'
  end

  def test_missing_image_caption
    refute benefits(:missing_image_caption_benefit).valid?, 'image_caption should be required'
  end

  def test_missing_object_title
    refute benefits(:missing_object_title_benefit).valid?, 'object_title should be required'
  end

  def test_missing_object_embed_code
    refute benefits(:missing_object_embed_code_benefit).valid?, 'object_embed_code should be required'
  end
end
