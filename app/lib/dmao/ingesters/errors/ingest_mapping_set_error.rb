module DMAO
  module Ingesters
    module Errors

      class IngestMappingSetError < StandardError

        attr_reader :validation_errors

        def initialize(msg="Error setting mapping between uuids", validation_errors=nil)

          @validation_errors = validation_errors

          super(msg)

        end

      end

    end
  end
end