module DMAO
  module Ingesters

    class IngestFileError < IngestError

      def initialize(msg="Error finding file", validation_errors=nil)

        super(msg, validation_errors)

      end

    end

  end
end