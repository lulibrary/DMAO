module Admin
  module Jobs
    module Institution
      class ProcessIngestJob < ApplicationJob
        queue_as :default

        def perform(ingest_job_id)

          begin
            ::IngestJob.find(ingest_job_id)
          rescue ActiveRecord::RecordNotFound => e
            Rails.logger.error "[#{self.class}] [#{job_id}] Failed to find ingest job in system with id #{ingest_job_id}"
          end

        end
      end
    end
  end
end
