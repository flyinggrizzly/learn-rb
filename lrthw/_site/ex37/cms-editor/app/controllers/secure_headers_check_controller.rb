# Empty page for checking to see if secure headers are set
class SecureHeadersCheckController < ApplicationController
  def index
    @intro_message = 'You should see a bunch of headers set such as X-XSS-Protection'
  end
end
