require 'test_helper'

module Admin

  class InstitutionsControllerTest < ActionController::TestCase

    include Devise::Test::ControllerHelpers

    def setup

      @request.env['devise.mapping'] = Devise.mappings[:dmao_admin]
      sign_in dmao_admins(:one)
      @institution_params = valid_institution

    end

    # creation tests

    test 'redirects to institution path on successfully creating an institution' do

      post :create, params: @institution_params

      assert_redirected_to admin_institution_path(Institution.last)

    end

    test 'returns with errors when identifier is blank' do

      params = @institution_params
      params[:institution][:identifier] = nil

      post :create, params: params

      errors = assigns(:institution).errors

      assert_not_empty errors
      assert errors.details.keys.include? :identifier

    end

    # view institution tests

    test 'returns 404 when no institution found for id' do

      get :show, params: { :id => 12345 }

      assert_response 404

    end

    test 'returns institution for valid id' do

      get :show, params: { :id => Institution.last.id }

      assert assigns(:institution)

    end

    test 'returns institution admins for valid id' do

      get :show, params: { :id => Institution.last.id }

      assert assigns(:institution_admins)

    end

    # editing tests

    test 'redirects to institution path on successfully editing an institution' do
      institution = institutions(:luve)
      patch :update, params:{id: institution.id, institution:{url: 'https://blah.com'}}
      assert_redirected_to admin_institution_path(Institution.last)
    end

    test 'returns 404 when no institution found for id when editing' do

      patch :update, params:{id: 12345, institution:{url: 'https://blah.com'}}

      assert_response 404

    end

    test 'returns to edit form on failed update' do
      institution = institutions(:luve)
      patch :update, params:{id: institution.id, institution:{name: nil}}
      assert_template 'edit'
      assert assigns(:institution).errors.any?
    end

    # admin institution delete tests

    test 'redirects to all institutions list on successfully deleting an institution' do
      institution = institutions(:luve)
      delete :destroy, params:{id: institution.id}
      assert_redirected_to admin_institutions_path
    end

    test 'returns 404 when no institution found for id when deleting' do

      delete :destroy, params:{id: 12345}

      assert_response 404

    end

    test 'removes institution on successful delete' do
      institution = institutions(:luve)
      assert_difference 'Institution.count', -1 do
        delete :destroy, params:{id: institution.id}
      end
    end

    private

    def valid_institution
      {
        institution: {
            name: 'Lune Valley Enterprise University',
            description: 'Worst university in the north west.',
            identifier: 'luve-u2',
            contact_name: 'John Smith',
            contact_email: 'john@example.com',
            contact_phone_number: '00000 000000',
            url: 'example.com'
        }
      }

    end

  end

end
