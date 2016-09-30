module Admin
  module Jobs
    class IngesterIngestJob < ApplicationJob
      queue_as :default

      def perform(ingester_name, ingester_options)

        puts "PERFORMING INGESTER INGEST JOB"
        puts "#{ingester_name} - #{ingester_options}"

      end

    end
  end
end