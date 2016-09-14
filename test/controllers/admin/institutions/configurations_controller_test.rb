require 'test_helper'

module Admin
  module Institutions

    class ConfigurationsControllerTest < ActionController::TestCase

      include Devise::Test::ControllerHelpers

      def setup

        @request.env['devise.mapping'] = Devise.mappings[:dmao_admin]
        sign_in dmao_admins(:one)

        @institution = institutions(:luve)

      end

      test 'New - assigns configuration to that of the institution when it exists' do

        get :new, params: { institution_id: @institution.id }

        assert_equal @institution.configuration, assigns(:configuration)

      end

      test 'New - assigns empty configuration if one does not exist for institution' do

        test_institution = institutions(:test)

        get :new, params: { institution_id: test_institution.id }

        configuration = assigns(:configuration)

        assert_instance_of Institution::Configuration, configuration
        assert_equal test_institution.id, configuration.institution_id
        assert_instance_of Configuration::SystemConfiguration, configuration.systems_configuration

      end

      test 'New - returns 404 if institution does not exist' do

        get :new, params: { institution_id: 0 }

        assert_response :not_found

      end

    end

  end
end