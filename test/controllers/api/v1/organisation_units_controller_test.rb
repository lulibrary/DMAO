require 'test_helper'

module Api
  module V1

    class OrganisationUnitsControllerTest < ActionController::TestCase

      def setup

        @valid_token = service_api_tokens(:one).token
        @invalid_token = "abcd1234"

        @valid_institution_id = institutions(:luve).id

        @org_unit_params = valid_org_unit
        @org_unit_update_params = valid_org_unit_update

        @child_org_unit = institution_organisation_units(:one)

      end

      test 'returns 401 unauthorised when trying to add organisation unit' do

        set_token_header @invalid_token

        assert_no_difference "Institution::OrganisationUnit.unscoped.count" do

          post :create, params: @org_unit_params

        end

        assert_response :unauthorized
        assert_equal "Invalid service API token", response.body

      end

      test 'returns 201 created with organisation unit when successfully created' do

        set_token_header @valid_token

        assert_difference "Institution::OrganisationUnit.unscoped.count" do
          post :create, params: @org_unit_params
        end

        assert_response :created

        assert_serializer "Api::V1::OrganisationUnitSerializer"

      end

      test 'returns 404 not found when institution id is not specified' do

        params = @org_unit_params
        params.delete(:institution_id)

        set_token_header @valid_token

        assert_no_difference "Institution::OrganisationUnit.unscoped.count" do
          post :create, params: @org_unit_params
        end

        assert_response :not_found

        parsed_response = JSON.parse(response.body)

        assert parsed_response["errors"]
        assert parsed_response["errors"]["institution_id"]

        assert_equal "Institution not found for institution id ", parsed_response["errors"]["institution_id"]

      end

      test 'returns 404 not found when institution id is empty' do

        params = @org_unit_params
        params[:institution_id] = ""

        set_token_header @valid_token

        assert_no_difference "Institution::OrganisationUnit.unscoped.count" do
          post :create, params: @org_unit_params
        end

        assert_response :not_found

        parsed_response = JSON.parse(response.body)

        assert parsed_response["errors"]
        assert parsed_response["errors"]["institution_id"]

        assert_equal "Institution not found for institution id ", parsed_response["errors"]["institution_id"]

      end

      test 'returns 404 not found when institution id is invalid' do

        params = @org_unit_params
        params[:institution_id] = 12345

        set_token_header @valid_token

        assert_no_difference "Institution::OrganisationUnit.unscoped.count" do
          post :create, params: @org_unit_params
        end

        assert_response :not_found

        parsed_response = JSON.parse(response.body)

        assert parsed_response["errors"]
        assert parsed_response["errors"]["institution_id"]

        assert_equal "Institution not found for institution id 12345", parsed_response["errors"]["institution_id"]

      end

      test 'returns unprocessable entity when organisation unit name is missing' do

        @org_unit_params.delete(:name)

        set_token_header @valid_token

        assert_no_difference "Institution::OrganisationUnit.unscoped.count" do
          post :create, params: @org_unit_params
        end

        assert_response :unprocessable_entity

        parsed_response = JSON.parse(response.body)

        assert parsed_response["errors"]
        assert parsed_response["errors"]["name"]

        assert_includes parsed_response["errors"]["name"], "can't be blank"

      end

      test 'returns unprocessable entity when organisation unit is invalid' do

        @org_unit_params.delete(:system_uuid)

        set_token_header @valid_token

        assert_no_difference "Institution::OrganisationUnit.unscoped.count" do
          post :create, params: @org_unit_params
        end

        assert_response :unprocessable_entity

        parsed_response = JSON.parse(response.body)

        assert parsed_response["errors"]
        assert parsed_response["errors"]["system_uuid"]

        assert_includes parsed_response["errors"]["system_uuid"], "can't be blank"

      end

      test 'UPDATE - return 401 unauthorised when trying to update organisation unit with invalid auth' do

        set_token_header @invalid_token

        patch :update, params: @org_unit_update_params

        assert_response :unauthorized
        assert_equal "Invalid service API token", response.body

      end

      test 'UPDATE - return 200 ok when updating organisation unit successfully' do

        set_token_header @valid_token

        patch :update, params: @org_unit_update_params

        assert_response :ok

        assert_serializer "Api::V1::OrganisationUnitSerializer"

      end

      test "UPDATE - sets parent attribute on organisation unit when specified" do

        set_token_header @valid_token

        patch :update, params: @org_unit_update_params

        assert_response :ok

        assert_serializer "Api::V1::OrganisationUnitSerializer"

        org_unit = Institution::OrganisationUnit.unscoped.find(institution_organisation_units(:one).id)

        assert_not_nil org_unit.parent

      end

      test 'UPDATE - returns 404 not found when institution id is not specified' do

        @org_unit_update_params.delete(:institution_id)

        set_token_header @valid_token

        patch :update, params: @org_unit_update_params

        assert_response :not_found

        parsed_response = JSON.parse(response.body)

        assert parsed_response["errors"]
        assert parsed_response["errors"]["institution_id"]

        assert_equal "Institution not found for institution id ", parsed_response["errors"]["institution_id"]

      end

      test 'UPDATE - returns 404 not found when institution id is empty' do

        @org_unit_update_params[:institution_id] = ""

        set_token_header @valid_token

        patch :update, params: @org_unit_update_params

        assert_response :not_found

        parsed_response = JSON.parse(response.body)

        assert parsed_response["errors"]
        assert parsed_response["errors"]["institution_id"]

        assert_equal "Institution not found for institution id ", parsed_response["errors"]["institution_id"]

      end

      test 'UPDATE - returns 404 not found when institution id is invalid' do

        @org_unit_update_params[:institution_id] = 12345

        set_token_header @valid_token

        patch :update, params: @org_unit_update_params

        assert_response :not_found

        parsed_response = JSON.parse(response.body)

        assert parsed_response["errors"]
        assert parsed_response["errors"]["institution_id"]

        assert_equal "Institution not found for institution id 12345", parsed_response["errors"]["institution_id"]

      end

      test 'UPDATE - returns 404 not found when id for organisation unit is empty' do

        @org_unit_update_params[:id] = ""

        set_token_header @valid_token

        patch :update, params: @org_unit_update_params

        assert_response :not_found

        parsed_response = JSON.parse(response.body)

        assert parsed_response["errors"]
        assert parsed_response["errors"]["organisation_unit"]

        assert_equal "Organisation unit not found for organisation unit id ", parsed_response["errors"]["organisation_unit"]

      end

      test 'UPDATE - returns 404 not found when id for organisation unit is invalid' do

        @org_unit_update_params[:id] = 12345

        set_token_header @valid_token

        patch :update, params: @org_unit_update_params

        assert_response :not_found

        parsed_response = JSON.parse(response.body)

        assert parsed_response["errors"]
        assert parsed_response["errors"]["organisation_unit"]

        assert_equal "Organisation unit not found for organisation unit id 12345", parsed_response["errors"]["organisation_unit"]

      end

      test 'UPDATE - returns 422 unprocessable when parent uuid for organisation unit is invalid' do

        @org_unit_update_params[:parent_uuid] = 12345

        set_token_header @valid_token

        patch :update, params: @org_unit_update_params

        assert_response :unprocessable_entity

        parsed_response = JSON.parse(response.body)

        assert parsed_response["errors"]
        assert parsed_response["errors"]["parent_uuid"]

        assert_equal "Organisation unit not found for parent uuid 12345", parsed_response["errors"]["parent_uuid"]

      end

      test 'UPDATE - returns 422 unprocessable when organisation unit name is set to empty' do

        set_token_header @valid_token

        @org_unit_update_params[:name] = ""

        patch :update, params: @org_unit_update_params

        assert_response :unprocessable_entity

        parsed_response = JSON.parse(response.body)

        assert parsed_response["errors"]

        assert parsed_response["errors"]["name"]

        assert_includes parsed_response["errors"]["name"], "can't be blank"

      end

      private

      def set_token_header token
        headers = { authorization: "Token #{token}" }
        request.headers.merge! headers
      end

      def valid_org_unit
        {
            institution_id: @valid_institution_id,
            name: "Faculty of Arts and Social Sciences",
            description: "",
            url: "",
            system_uuid: "0b397b51-b90c-4fee-8e24-e01f9ae333f2",
            system_modified_at: 1474541182,
            isni: "",
            unit_type: "Faculty"
        }
      end

      def valid_org_unit_update
        {
            institution_id: @valid_institution_id,
            id: institution_organisation_units(:one).id,
            parent_uuid: institution_organisation_units(:two).id
        }
      end

    end

  end
end