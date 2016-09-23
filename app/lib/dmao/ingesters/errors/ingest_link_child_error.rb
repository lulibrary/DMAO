module DMAO
  module Ingesters
    module Errors

      class IngestLinkChildError < StandardError

        attr_reader :validation_errors

        def initialize(msg="Error finding child to link from", validation_errors=nil)

          @validation_errors = validation_errors

          super(msg)

        end

      end

    end
  end
end