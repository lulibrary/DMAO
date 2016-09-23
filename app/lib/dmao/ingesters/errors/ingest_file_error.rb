module DMAO
  module Ingesters
    module Errors

      class IngestFileError < IngestError

        def initialize(msg="Error finding file", validation_errors=nil)

          super(msg, validation_errors)

        end

      end

    end
  end
end