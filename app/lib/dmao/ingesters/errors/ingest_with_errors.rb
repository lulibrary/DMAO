module DMAO
  module Ingesters
    module Errors

      class IngestWithErrors < IngestError

        attr_reader :error_log_file

        def initialize(msg="Ingest completed with errors", log_file=nil, validation_errors=nil)

          @error_log_file = log_file

          super(msg, validation_errors)

        end

      end

    end
  end
end