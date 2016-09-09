require 'test_helper'

module Institutions

  class InstitutionDetailsTest < ActionController::TestCase

    def setup
      @controller = InstitutionDetailsTestController.new(:test) { head(:ok) }
      @routes.draw { get 'test_route' => 'institutions/institution_details_test#test'}
      @existing_institution = institutions(:luve)
      @non_existing_institution = @existing_institution.dup
      @non_existing_institution.identifier = "thisdoesntexist"
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

      assert_equal assigns(:institution).identifier, @existing_institution.identifier

    end

  end

  class InstitutionDetailsTestController < ActionController::Base

    include Institutions::InstitutionDetails

    def initialize(method_name, &method_body)
      self.class.send(:define_method, method_name, method_body)
    end

  end

end