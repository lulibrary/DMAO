module DMAO
  module Ingesters

    ALL = []
    DETAILS = {}
    ORG_INGESTERS = {}

    def self.register name, display_name, version, type, ingester

      details = { name: name, display_name: display_name, version: version, type: type }

      ALL.insert(-1, name)
      DETAILS[name] = details

      ORG_INGESTERS[name] = ingester if type == :organisation

    end

  end
end