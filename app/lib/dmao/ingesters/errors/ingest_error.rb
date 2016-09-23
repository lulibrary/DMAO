module DMAO
  module Ingesters
    module Errors

      class IngestError < StandardError

        attr_reader :validation_errors

        def initialize(msg="Error ingesting object to system", validation_errors=nil)

          @validation_errors = validation_errors

          super(msg)

        end

      end

    end
  end
end