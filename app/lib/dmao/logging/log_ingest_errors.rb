module DMAO
  module Logging

    module LogIngestErrors

      attr_reader :logged_errors

      def create_logger filename

        @logger = DMAO::Ingesters::IngestLogger.new filename
        @logged_errors = false

      end

      def log_ingest_errors system_uuid, error_message, errors={}

        @logged_errors = true

        @logger.error("#{system_uuid} - #{error_message} - #{errors.to_json}")

      end

      def close_log_file
        @logger.close
      end

    end

  end
end