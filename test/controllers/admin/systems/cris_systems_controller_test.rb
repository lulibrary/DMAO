require 'test_helper'

module Admin
  module Systems
    class CrisSystemsControllerTest < ActionController::TestCase

      include Devise::Test::ControllerHelpers

      def setup

        @request.env['devise.mapping'] = Devise.mappings[:dmao_admin]
        sign_in dmao_admins(:one)

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
          post :create, params: { cris_system: { name: 'Testing Cris System', description: 'Testing CRIS Systems', version: 1 } }
        end

      end

      test 'Create - should redirect to cris system details when succesfully created' do

        post :create, params: { cris_system: { name: 'Testing Cris System', description: 'Testing CRIS Systems', version: 1 } }

        assert_redirected_to admin_systems_cris_system_path ::Systems::CrisSystem.last

      end

      test 'Create - should return the new cris system form when invalid cris system' do

        post :create, params: { cris_system: { name: nil, description: 'Testing CRIS Systems', version: 1 } }

        assert_template :new

        assert assigns(:cris_system).errors.any?

      end

    end
  end
end