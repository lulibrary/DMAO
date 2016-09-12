require 'test_helper'

module Institutions

  class UsersControllerTest < ActionController::TestCase

    include Devise::Test::ControllerHelpers

    def setup

      @institution_admin = institution_admins(:one)
      @institution = @institution_admin.institution

      @institution_user = valid_institution_user

      @request.env['devise.mapping'] = Devise.mappings[:institution_admin]

      sign_in institution_admins(:one), scope: :institution_admin

    end

    test 'sets institution id for new institution user to that of the institution logged in as' do

      get :new, params: { institution_identifier: @institution.identifier }

      assert_equal @institution.id, assigns(:institution_user).institution_id

    end

    test 'assigns institution user to be instance of institution user' do

      get :new, params: { institution_identifier: @institution.identifier }

      assert assigns(:institution_user)

      assert_instance_of Institution::User, assigns(:institution_user)

    end

    test 'returns new institution user form' do

      get :new, params: { institution_identifier: @institution.identifier }

      assert_template :new

    end

    test 'Create - redirects to institution users path on successfully creating a user' do

      post :create, params: @institution_user.merge({institution_identifier: @institution.identifier})

      assert_redirected_to institution_users_path

    end

    test 'Create - returns to new form with errors when name is blank' do

      params = @institution_user
      params[:institution_user][:name] = nil

      post :create, params: params.merge({institution_identifier: @institution.identifier})

      errors = assigns(:institution_user).errors

      assert_not_empty errors
      assert errors.details.keys.include? :name
      assert_template :new

    end

    test 'Create - returns to new form with errors when email is blank' do

      params = @institution_user
      params[:institution_user][:email] = nil

      post :create, params: params.merge({institution_identifier: @institution.identifier})

      errors = assigns(:institution_user).errors

      assert_not_empty errors
      assert errors.details.keys.include? :email
      assert_template :new

    end

    test 'Create - should generate random password for user when creating them' do

      Institutions::UsersController.any_instance.expects(:generate_password).times(1).returns({password: "password", password_confirmation: "password"})

      post :create, params: @institution_user.merge({institution_identifier: @institution.identifier})

    end

    test 'Index - should return all users for the chosen institution' do

      get :index, params: { institution_identifier: @institution.identifier }

      assert assigns(:institution_users)

      assert_not_empty assigns(:institution_users)

      assert_equal @institution.users.count, assigns(:institution_users).length

    end

    test 'Edit - returns 404 when no user found in institution for id' do

      get :edit, params: { institution_identifier: @institution.identifier, id: 0 }

      assert_response :not_found

    end

    test 'Edit - returns edit form when user id is valid' do

      get :edit, params: { institution_identifier: @institution.identifier, id: @institution.users.first.id }

      assert assigns(:institution_user)

      assert_template :edit

    end

    test 'Update - returns 404 when no user found in institution for id' do

      patch :update, params: { institution_identifier: @institution.identifier, id: 0, institution_user: { name: 'Updated Name' } }

      assert_response :not_found

    end

    test 'Update - return to showing institution users details on successfully editing user' do

      patch :update, params: { institution_identifier: @institution.identifier, id: @institution.users.first.id, institution_user: { name: 'Updated Name' } }

      assert_redirected_to institution_user_path(id: @institution.users.first)

    end

    test 'Update - name for institution user should updated and saved' do

      patch :update, params: { institution_identifier: @institution.identifier, id: @institution.users.first.id, institution_user: { name: 'Updated Name' } }

      @institution.reload

      assert_equal 'Updated Name', @institution.users.first.name

    end

    test 'Update - return to edit form on failed update' do

      patch :update, params: { institution_identifier: @institution.identifier, id: @institution.users.first.id, institution_user: { name: nil } }

      assert_template :edit

      assert assigns(:institution_user).errors.any?

    end

    private

    def valid_institution_user

      {
          institution_user: {
              name: 'Sombody',
              email: 'john@example.com',
          }
      }

    end

  end

end