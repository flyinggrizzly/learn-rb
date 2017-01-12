require 'test_helper'

class PartnerTest < ActiveSupport::TestCase
  def test_valid
    assert partners(:maximum_lengths_valid_partner).valid?, 'Maximum lengths should have been valid - has someone reduced a length?'
  end

  def test_missing_logo_alt
    refute partners(:missing_logo_alt_partner).valid?, 'Partner should not have been valid'
  end

  def test_missing_logo_url
    refute partners(:missing_logo_url_partner).valid?, 'Partner should not have been valid'
  end

  def test_missing_link_text
    refute partners(:missing_link_text_partner).valid?, 'Partner should not have been valid'
  end

  def test_missing_link_url
    refute partners(:missing_link_url_partner).valid?, 'Partner should not have been valid'
  end

  def test_invalid_url
    refute partners(:logo_url_invalid_partner).valid?, 'Partner should not have been valid'
    refute partners(:link_url_invalid_partner).valid?, 'Partner should not have been valid'
  end
end
