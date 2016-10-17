require 'test_helper'

module DMAO
  class IngestersTest < ActiveSupport::TestCase

    test 'sets url constant to that specified in config file' do

      config_url = Rails.application.config_for(:dmao)["ingest_service_base_url"]

      assert_equal config_url, DMAO::Ingesters::URL

    end

  end
end