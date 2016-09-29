module Admin

  module Institutions

    class IngestJobsController < AdminController

      def create

        begin

          institution = Institution.find params[:institution_id]

          @ingest_job = create_new_ingest_job institution

          if @ingest_job.save

            ::Admin::Jobs::Institution::ProcessIngestJob.perform_later @ingest_job.id

            respond_to do |format|

              format.json { render json: @ingest_job }
              format.js
            end

          end

        rescue ActiveRecord::RecordNotFound, ActionController::UnknownFormat

          head(:not_found)

        end

      end

      private

      def create_new_ingest_job institution

        ingest_job = {
            ingest_type: "ingest",
            ingest_mode: "manual",
            ingest_area: params[:ingest_job][:ingest_area],
            institution: institution,
            status: "new"
        }

        ingest_job = IngestJob.new ingest_job

        ingest_job.ingest_data_file = params[:ingest_job][:ingest_data_file]

        ingest_job

      end

    end

  end

end