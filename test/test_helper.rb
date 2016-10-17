ENV['RAILS_ENV'] ||= 'test'
require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha/mini_test'
require 'webmock/minitest'
require 'vcr'

VCR.configure do |c|
    c.cassette_library_dir = "test/cassettes"
    c.hook_into :webmock
    c.ignore_hosts 'codeclimate.com'
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
