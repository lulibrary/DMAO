module Admin
  module Jobs
    class IngesterIngestJob < ApplicationJob
      queue_as :ingests

      before_perform do

        institution_id = self.arguments.first

        ::Institution.current_id = institution_id

      end

      after_perform do
        ::Institution.current_id = nil
      end

      def perform(_institution_id, ingester_name, ingester_options)

        ingester = new_ingester ingester_name

        begin

          if is_file_ingester? ingester_name
            ingest = ingester.ingest({file: ingester_options["file"]})
          else
            ingest = ingester.ingest ingester_options
          end

          ingest_file = ingest.get_log_file_path

        rescue DMAO::Ingesters::Errors::IngestWithErrors => e

          ingest_file = e.error_log_file

        end

        ingest_job = ::IngestJob.find(ingester_options["ingest_job_id"])

        File.open ingest_file do |f|
          ingest_job.ingest_log_file = f
        end

        ingest_job.save

      end

      def new_ingester ingester_name

        case DMAO::Ingesters::DETAILS[ingester_name.to_sym][:type]

          when :organisation
            DMAO::Ingesters::ORG_INGESTERS[ingester_name.to_sym].new
          else
            raise ::DMAO::Ingesters::Errors::UnknownIngester

        end

      end

      def is_file_ingester? ingester_name

        DMAO::Ingesters::FILE_INGESTERS.include? ingester_name.to_sym

      end

    end
  end
end