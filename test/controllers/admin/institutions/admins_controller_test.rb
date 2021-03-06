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

      test 'Edit - returns 404 when no institution found for id when editing admin user' do

        get :edit, params: { institution_id: 12345, id: 12345 }

        assert_response 404

      end

      test 'Edit - returns 404 when no admin user found in institution for id' do

        get :edit, params: { institution_id: @institution.id, id: 0 }

        assert_response 404

      end

      test 'Edit - returns edit form when institution id and admin id are valid' do

        get :edit, params: { institution_id: @institution.id, id: @institution.admins.first.id }

        assert_template :edit

      end

      test 'Update - returns 404 when no institution found for id when updating admin user' do

        patch :update, params: { institution_id: 0, id: 0, institution_admin: { name: 'Updated name' } }

        assert_response :not_found

      end

      test 'Update - returns 404 when no admin user found in institution for id when updating admin user' do

        patch :update, params: { institution_id: @institution.id, id: 0, institution_admin: { name: 'Updated name' } }

        assert_response :not_found

      end

      test 'Update - returns to showing institution admin details on successfully editing admin' do

        patch :update, params: { institution_id: @institution.id, id: @institution.admins.first.id, institution_admin: { name: 'Updated name' } }

        assert_redirected_to admin_institution_admin_path(@institution, @institution.admins.first)

      end

      test 'Update - name for institution admin should be updated and saved' do

        patch :update, params: { institution_id: @institution.id, id: @institution.admins.first.id, institution_admin: { name: 'Updated name' } }

        @institution.reload

        assert_equal 'Updated name', @institution.admins.first.name

      end

      test 'Update - returns to edit form on failed update' do

        patch :update, params: { institution_id: @institution.id, id: @institution.admins.first.id, institution_admin: { name: nil } }

        assert_template :edit

        assert assigns(:institution_admin).errors.any?

      end

      test 'Delete - return 404 when no institution found for id when deleting admin user' do

        delete :destroy, params: { institution_id: 0, id: 0 }

        assert_response :not_found

      end

      test 'Delete - return 404 when no admin user found in institution for id when deleting admin' do

        delete :destroy, params: { institution_id: @institution.id, id: 0 }

        assert_response :not_found

      end

      test 'Delete - redirects to institution details on successfully deleting an institution admin user' do

        delete :destroy, params: { institution_id: @institution.id, id: @institution.admins.first.id }

        assert_redirected_to admin_institution_path(@institution)

      end

      test 'Delete - removes an institution admin on successful delete' do

        assert_difference 'Institution::Admin.unscoped.count', -1 do
          delete :destroy, params: { institution_id: @institution.id, id: @institution.admins.first.id }
        end

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
