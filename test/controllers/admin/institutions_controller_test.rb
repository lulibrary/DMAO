require 'test_helper'

module Admin

  class InstitutionsControllerTest < ActionController::TestCase

    def setup

      @institution_params = valid_institution

    end

    test 'redirects to institution path on successfully creating an institution' do

      post :create, params: @institution_params

      assert_redirected_to admin_institution_path(Institution.last)

    end

    test "returns with errors when identifier is blank" do

      params = @institution_params
      params[:institution][:identifier] = nil

      post :create, params: params

      errors = assigns(:institution).errors

      assert_not_empty errors
      assert errors.details.keys.include? :identifier

    end

    test "returns 404 when no institution found for id" do

      get :show, params: { :id => 12345 }

      assert_response 404

    end

    test "returns institution for valid id" do

      get :show, params: { :id => Institution.last.id }

      assert assigns(:institution)

    end

    private

    def valid_institution
      {
        institution: {
            name: "Lune Valley Enterprise University",
            description: "Worst university in the north west.",
            identifier: "luve-u2",
            contact_name: "John Smith",
            contact_email: "john@example.com",
            contact_phone_number: "00000 000000",
            url: "example.com"
        }
      }

    end

  end

end