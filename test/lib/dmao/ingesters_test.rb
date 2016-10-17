require 'test_helper'

module DMAO
  class IngestersTest < ActiveSupport::TestCase

    test 'sets url constant to that specified in config file' do

      config_url = Rails.application.config_for(:dmao)["ingest_service_base_url"]

      assert_equal config_url, DMAO::Ingesters::URL

    end

    test 'get organisation ingesters should call ingest service' do

      VCR.use_cassette("get_organisation_ingesters") do

        ingesters = DMAO::Ingesters.get_organisation_ingesters
        
        ingester = ingesters.first[1]
        ingester_name = ingesters.first[0]

        assert_equal 1, ingesters.length
        assert_equal "json_organisation_ingester_0_1", ingester_name
        assert_equal "json_organisation_ingester", ingester["name"]
        assert_equal "JSON File organisation ingester", ingester["display_name"]
        assert_equal 0.1, ingester["version"]
        assert_equal "organisation", ingester["ingest_area"]
        assert_equal "file", ingester["ingester_type"]

      end

    end

  end
end