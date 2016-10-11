require 'test_helper'

class Service::ApiTokenTest < ActiveSupport::TestCase

  def setup
    @api_token = service_api_tokens(:one)
  end

  test 'should be a valid api token' do
    assert @api_token.valid?
  end

  test 'setting token to nil should generate new token and be valid' do

    Service::ApiToken.any_instance.expects(:generate_api_token).once.returns("abcdefghijkl")

    @api_token.token = nil

    assert @api_token.valid?

    assert_equal "abcdefghijkl", @api_token.token

  end

  test 'should be invalid without service name' do
    @api_token.service_name = nil
    assert_not @api_token.valid?
  end

  test 'api token should be generated before save' do

    api_token = Service::ApiToken.new(service_name: "Test Service")

    assert_nil api_token.token

    assert api_token.save

    assert_not_nil api_token.token

  end

  test 'api token should be generated from uuid' do

    SecureRandom.expects(:uuid).once.returns("abcd-efgh-ijkl")

    api_token = Service::ApiToken.new(service_name: "Test Service")

    assert api_token.save

    assert_equal "abcdefghijkl", api_token.token

  end

  test 'api token should not be generated if set' do

    SecureRandom.expects(:uuid).never

    api_token = Service::ApiToken.new(service_name: "Test Service")
    api_token.token = "abcdefghijkl"

    assert api_token.save

  end

end
