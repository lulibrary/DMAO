module DMAO
  module Ingesters
    module Errors

      class IngestSaveError < StandardError

        attr_reader :validation_errors

        def initialize(msg="Error saving to system", validation_errors=nil)

          @validation_errors = validation_errors

          super(msg)

        end

      end

    end
  end
end