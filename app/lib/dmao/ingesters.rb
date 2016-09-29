module DMAO
  module Ingesters

    ALL = []
    DETAILS = {}
    ORG_INGESTERS = {}
    FILE_INGESTERS = []

    VALID_INGESTER_TYPES = [:file, nil]

    VALID_INGEST_AREAS = [:organisation]
    INGEST_AREA_DISPLAY_NAMES = { organisation: "Organisation Structure" }

    def self.register name, display_name, version, type, ingester, ingester_type=nil

      raise DMAO::Ingesters::Errors::InvalidIngesterType.new unless VALID_INGESTER_TYPES.include? ingester_type

      details = { name: name, display_name: display_name, version: version, type: type, ingester_type: ingester_type }

      ALL.insert(-1, name)
      DETAILS[name] = details

      FILE_INGESTERS.insert(-1, name) if ingester_type == :file

      ORG_INGESTERS[name] = ingester if type == :organisation

    end

  end
end