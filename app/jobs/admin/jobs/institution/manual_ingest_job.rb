module Admin
  module Jobs
    module Institution
      class ManualIngestJob < ApplicationJob
        queue_as :default

        def perform(ingest_job_id)

          begin

            ingest_job = ::IngestJob.find(ingest_job_id)

            institution = ingest_job.institution

            configuration = institution.configuration

            ingester_name = get_ingester_name ingest_job.ingest_area, configuration

            ingester_options = get_ingester_options ingest_job.ingest_area, configuration

            ingester_options.merge!({ "ingest_job_id" => ingest_job_id, "file" => "#{CarrierWave.root}/#{ingest_job.ingest_data_file}" })

            ::Admin::Jobs::IngesterIngestJob.perform_later institution.id, ingester_name, ingester_options

          rescue ActiveRecord::RecordNotFound
            Rails.logger.error "[#{self.class}] [#{job_id}] Failed to find ingest job in system with id #{ingest_job_id}"
          end

        end

        def get_ingester_name ingest_area, configuration

          cris_system = configuration.systems_configuration.cris_system.details

          case ingest_area

            when "organisation"
              ingester = cris_system.organisation_ingester
            else
              raise ::DMAO::Ingesters::Errors::UnknownIngester

          end

          ingester

        end

        def get_ingester_options ingest_area, configuration

          config_values = configuration.systems_configuration.cris_system.configuration_values

          options = {}

          case ingest_area

            when "organisation"

              config_values.each do |config_value|

                options[config_value.configuration_key.name] = config_value.value

              end

            else
              raise ::DMAO::Ingesters::Errors::UnknownIngester

          end

          options

        end

      end
    end
  end
end
