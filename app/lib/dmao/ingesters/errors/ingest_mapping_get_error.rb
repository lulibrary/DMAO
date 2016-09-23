module DMAO
  module Ingesters
    module Errors

      class IngestMappingGetError < StandardError

        attr_reader :validation_errors

        def initialize(msg="Error getting mapping for uuid", validation_errors=nil)

          @validation_errors = validation_errors

          super(msg)

        end

      end

    end
  end
end