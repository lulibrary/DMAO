require 'test_helper'

module Admin
  module Systems
    class CrisSystemsControllerTest < ActionController::TestCase

      include Devise::Test::ControllerHelpers

      def setup

        @request.env['devise.mapping'] = Devise.mappings[:dmao_admin]
        sign_in dmao_admins(:one)

        @cris_system = systems_cris_systems(:one)

      end

      test 'New - Returns new cris system form' do

        get :new

        assert_template :new

      end

      test 'New - assigns new cris system' do

        get :new

        assert assigns(:cris_system)
        assert_instance_of ::Systems::CrisSystem, assigns(:cris_system)

      end

      test 'Create - should save new cris system if all field specified' do

        assert_difference '::Systems::CrisSystem.count' do
          post :create, params: { systems_cris_system: { name: 'Testing Cris System', description: 'Testing CRIS Systems', version: 1 } }
        end

      end

      test 'Create - should redirect to cris system details when succesfully created' do

        post :create, params: { systems_cris_system: { name: 'Testing Cris System', description: 'Testing CRIS Systems', version: 1 } }

        assert_redirected_to admin_systems_cris_system_path ::Systems::CrisSystem.last

      end

      test 'Create - should return the new cris system form when invalid cris system' do

        post :create, params: { systems_cris_system: { name: nil, description: 'Testing CRIS Systems', version: 1 } }

        assert_template :new

        assert assigns(:cris_system).errors.any?

      end

      test 'Create - should add configuration key when one is specified' do

        post :create, params: {
            systems_cris_system: {
                name: 'Testing System',
                description: 'Testing CRIS Systems',
                version: 1,
                configuration_keys_attributes: {
                    "0": {
                        name: 'testing-key-name',
                        display_name: 'Testing key name'
                    }
                }
            }
        }

        assert_equal 'testing-key-name', ::Systems::CrisSystem.last.configuration_keys.first.name
        assert_equal 'Testing key name', ::Systems::CrisSystem.last.configuration_keys.first.display_name

      end

      test 'Create - should add multiple configuration keys when they are specified' do

        assert_difference '::Systems::ConfigurationKey.count', 3 do

          post :create, params: {
              systems_cris_system: {
                  name: 'Testing System',
                  description: 'Testing CRIS Systems',
                  version: 1,
                  configuration_keys_attributes: {
                      "0": {
                          name: 'testing-key-name',
                          display_name: 'Testing key name'
                      },
                      "1": {
                          name: 'testing-key-name-1',
                          display_name: 'Testing key name one'
                      },
                      "2": {
                          name: 'testing-key-name-2',
                          display_name: 'Testing key name two'
                      }
                  }
              }
          }

        end

      end

      test 'Show - should assign cris system' do

        get :show, params: { id: @cris_system.id }

        assert assigns(:cris_system)

      end

      test 'Show - should return cris system with all its configuration keys' do

        get :show, params: { id: @cris_system.id }

        assert_equal @cris_system.configuration_keys.count, assigns(:cris_system).configuration_keys.count

      end

      test 'Show - should return cris system details view' do

        get :show, params: { id: @cris_system.id }

        assert_template :show

      end

      test 'Show - should return 404 if cannot find cris system with id' do

        get :show, params: { id: 0 }

        assert_response :not_found

      end

      test 'Index - should return cris systems with all cris systems' do

        get :index

        assert assigns(:cris_systems)

        assert_equal ::Systems::CrisSystem.count, assigns(:cris_systems).count

      end

      test 'Index - should load index view' do

        get :index

        assert_template :index

      end

    end
  end
end