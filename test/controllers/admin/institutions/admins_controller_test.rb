require 'test_helper'

module Admin

  module Institutions

    class AdminsControllerTest < ActionController::TestCase

      include Devise::Test::ControllerHelpers

      def setup

        @request.env['devise.mapping'] = Devise.mappings[:dmao_admin]
        sign_in dmao_admins(:one)
        @admin_params = valid_admin

        @institution = institutions(:luve)

      end

      test 'redirects to institution admin path on successfully creating an institution admin' do

        post :create, params: @admin_params.merge({institution_id: @institution.id})

        assert_redirected_to admin_institution_admin_path(id: Institution::Admin.unscoped.last)

      end

      test 'returns with errors when name is blank' do

        params = @admin_params
        params[:institution_admin][:name] = nil

        post :create, params: params.merge({institution_id: @institution.id})

        errors = assigns(:institution_admin).errors

        assert_not_empty errors
        assert errors.details.keys.include? :name

      end


      test 'returns 404 when no institution found for id when viewing new admin user form' do

        get :new, params: {:institution_id => 12345}

        assert_response 404

      end

      test 'returns 404 when no institution found for id when creating new admin user' do

        post :create, params: @admin_params.merge({institution_id: 12345})

        assert_response 404

      end

      private

      def valid_admin
        {
            institution_admin: {
                name: 'Sombody',
                email: 'john@example.com',
            }
        }

      end

    end

  end

end
