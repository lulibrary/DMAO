require 'test_helper'

module API
  module Authentication

    class ServiceTokenAuthTest < ActionController::TestCase

      def setup

        @controller = ServiceTokenAuthTestController.new(:test) { render plain: "Success" }
        @routes.draw { get 'test_route' => 'api/authentication/service_token_auth_test#test' }
        @token = service_api_tokens(:one)
        @invalid_token = "abcd1234"

      end

      def teardown
        Rails.application.reload_routes!
      end

      test 'should return 401 is invalid token sent' do

        set_token_header @invalid_token

        get :test

        assert_response :unauthorized

        assert_equal "Invalid service API token", response.body

      end

      test 'should return 200 if valid token is sent' do

        set_token_header @token.token

        get :test

        assert_response :ok

        assert_equal "Success", response.body

      end

      private

      def set_token_header token

        headers = { authorization: "Token #{token}" }

        request.headers.merge! headers

      end

    end

    class ServiceTokenAuthTestController < ActionController::Base

      include API::Authentication::ServiceTokenAuth

      def initialize(method_name, &method_body)
        self.class.send(:define_method, method_name, method_body)
      end

    end

  end
end