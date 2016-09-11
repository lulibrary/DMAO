require 'test_helper'

module Institutions

  class UsersControllerTest < ActionController::TestCase

    include Devise::Test::ControllerHelpers

    def setup

      @institution_admin = institution_admins(:one)
      @institution = @institution_admin.institution

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

  end

end