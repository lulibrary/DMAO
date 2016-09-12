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