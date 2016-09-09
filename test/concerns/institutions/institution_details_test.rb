require 'test_helper'

module Institutions

  class InstitutionDetailsTest < ActionController::TestCase

    def setup
      @controller = InstitutionDetailsTestController.new(:test) { render plain: Institution.current_id }
      @routes.draw { get 'test_route' => 'institutions/institution_details_test#test'}
      @existing_institution = institutions(:luve)
      @non_existing_institution = @existing_institution.dup
      @non_existing_institution.identifier = "thisdoesntexist"
    end

    def teardown
      Rails.application.reload_routes!
    end

    test 'returns 404 if cannot find institution' do

      get :test, params: { institution_identifier: @non_existing_institution.identifier }

      assert_response :not_found

    end

    test 'returns 200 if institution found' do

      get :test, params: { institution_identifier: @existing_institution.identifier }

      assert_response :ok

    end

    test 'should assign institution variable with correct identifier if found' do

      get :test, params: { institution_identifier: @existing_institution.identifier }

      assert assigns(:institution)

      assert_equal @existing_institution.identifier, assigns(:institution).identifier

    end

    test 'should return the correct institution id from current id on institution based on institution requesting as' do

      get :test, params: { institution_identifier: @existing_institution.identifier }

      assert_response :ok

      assert_equal @existing_institution.id.to_s, @response.body

    end

  end

  class InstitutionDetailsTestController < ActionController::Base

    include Institutions::InstitutionDetails

    def initialize(method_name, &method_body)
      self.class.send(:define_method, method_name, method_body)
    end

  end

end