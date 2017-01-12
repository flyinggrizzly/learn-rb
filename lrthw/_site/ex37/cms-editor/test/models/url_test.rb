require 'test_helper'

class UrlTest < ActiveSupport::TestCase
  def test_valid
    assert urls(:maximum_lengths_valid).valid?, 'Maximum lengths should have been valid - has someone reduced a length?'
  end

  def test_invalid_url
    refute urls(:invalid_url).valid?, 'URL should have failed validation'
  end
end
