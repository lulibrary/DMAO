module DMAO
  module Ingesters
    module Errors

      class IngestLinkParentError < StandardError

        attr_reader :validation_errors

        def initialize(msg="Error finding parent to link to", validation_errors=nil)

          @validation_errors = validation_errors

          super(msg)

        end

      end

    end
  end
end