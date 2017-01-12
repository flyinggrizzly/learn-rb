# Running coverage must be before anything else
# require 'simplecov'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def sample_file(filename='sample_file.txt')
    File.new("test/fixtures/attachment-files/#{filename}")
  end
end

# Capybara
require 'minitest/rails/capybara'
require 'rack_session_access/capybara'

# Make minitest output look better
require 'minitest/reporters'
MiniTest::Reporters.use! [
  MiniTest::Reporters::DefaultReporter.new,
  MiniTest::Reporters::JUnitReporter.new
]
