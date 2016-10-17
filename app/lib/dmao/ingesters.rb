module DMAO
  module Ingesters

    INGEST_AREA_DISPLAY_NAMES = { organisation: "Organisation Structure" }
    URL = Rails.application.config_for(:dmao)["ingest_service_base_url"]

    def self.get_organisation_ingesters
      response = RestClient.get "#{URL}/ingesters/organisation"
      JSON.parse(response)
    end

  end
end