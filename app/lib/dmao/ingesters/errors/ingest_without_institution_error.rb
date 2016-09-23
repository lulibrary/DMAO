module DMAO
  module Ingesters
    module Errors

      class IngestWithoutInstitutionError < StandardError

        attr_reader :validation_errors

        def initialize(msg="Institution current id must be set for ingesting to happen", validation_errors=nil)

          @validation_errors = validation_errors

          super(msg)

        end

      end

    end
  end
end