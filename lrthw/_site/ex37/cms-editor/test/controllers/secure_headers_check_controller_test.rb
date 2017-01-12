require 'test_helper'

# Test Secure Headers Check Controller
class SecureHeadersCheckControllerTest < ActionController::TestCase
  def test_secure_headers
    get :index
    assert @response
    assert @response.headers['X-XSS-Protection']
  end
end
