module DMAO
  module Ingesters

    ALL = []
    DETAILS = {}
    ORG_INGESTERS = {}
    FILE_INGESTERS = []

    def self.register name, display_name, version, type, ingester, ingester_type=nil

      details = { name: name, display_name: display_name, version: version, type: type, ingester_type: ingester_type }

      ALL.insert(-1, name)
      DETAILS[name] = details

      FILE_INGESTERS.insert(-1, name) if ingester_type == :file

      ORG_INGESTERS[name] = ingester if type == :organisation

    end

  end
end