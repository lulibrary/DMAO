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
        assert_instance_of ::Configuration::SystemConfiguration, configuration.systems_configuration

      end

      test 'New - returns 404 if institution does not exist' do

        get :new, params: { institution_id: 0 }

        assert_response :not_found

      end

      test 'Create - returns 404 if institution does not exist' do

        post :create, params: { institution_id: 0 }

        assert_response :not_found

      end

      test 'Create - creates a new configuration linked to the institution' do

        new_config = ::Institution::Configuration.new

        ::Institution::Configuration.expects(:new).times(1).returns(new_config)

        post :create, params: valid_configuration_params

      end

      test 'Create - redirects to show institution configuration details' do

        post :create, params: valid_configuration_params

        assert_redirected_to admin_institution_configuration_path(id: ::Institution::Configuration.last)

      end

      test 'Create - displays form if errors creating configuration' do

        ::Institution::Configuration.any_instance.expects(:save).once.returns(false)

        post :create, params: valid_configuration_params

        assert_template :new

      end

      test 'Create - should create new configuration version for institution on save' do

        post :create, params: valid_configuration_params

        assert_equal 1, ::Institution::Configuration.last.versions.count

      end

      test 'Create - should call create systems configuration' do

        new_system_config = ::Configuration::SystemConfiguration.new

        ::CreateSystemsConfiguration.any_instance.expects(:call).times(1).returns(new_system_config)

        post :create, params: valid_configuration_params

      end

      private

      def valid_configuration_params

        cris_system = systems_cris_systems(:one)

        config_key_ids = cris_system.configuration_keys.ids

        config_values = {}

        config_key_ids.each { |id| config_values[id.to_s] = { value: "testing key #{id} value" } }

        {
            institution_id: @institution.id,
            institution_configuration: {
                systems_configuration: {
                    cris_system: {
                        system_id: cris_system.id,
                        configuration_key_values: config_values
                    }
                }
            }
        }
      end

    end

  end
end