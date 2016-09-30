require 'test_helper'

module Admin

  module Institutions

    class IngestJobsControllerTest < ActionController::TestCase

      include Devise::Test::ControllerHelpers
      include ActiveJob::TestHelper

      def setup

        @request.env['devise.mapping'] = Devise.mappings[:dmao_admin]
        sign_in dmao_admins(:one)

        @institution = institutions(:luve)

      end

      test 'Create - should return status 200 with template when requesting as js' do

        post :create, xhr: true, params: { institution_id: @institution.id, ingest_job: { ingest_area: "organisation", ingest_data_file: fixture_file_upload("files/json_organisation_units.json") } }

        assert_template :create
        assert_response :ok
        assert assigns(:ingest_job)

      end

      test 'Create - should return 404 when requesting as js with invalid institution id' do

        post :create, xhr: true, params: { institution_id: 0, ingest_job: { ingest_area: "organisation", ingest_data_file: fixture_file_upload("files/json_organisation_units.json") } }

        assert_response :not_found

      end

      test 'Create - should schedule ingest job for ingesting the data' do

        assert_enqueued_jobs 0

        assert_enqueued_with(job: Admin::Jobs::Institution::ManualIngestJob) do

          post :create, xhr: true, params: { institution_id: @institution.id, ingest_job: { ingest_area: "organisation", ingest_data_file: fixture_file_upload("files/json_organisation_units.json") } }

        end

        assert_enqueued_jobs 1

      end

    end

  end

end
