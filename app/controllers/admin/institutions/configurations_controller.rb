module Admin
  module Institutions
    class ConfigurationsController < ::Admin::AdminController

      def new

        begin

          @institution = Institution.find params[:institution_id]

          @configuration = @institution.configuration || Institution::Configuration.new(institution: @institution)

        rescue ActiveRecord::RecordNotFound

          head(:not_found)

        end

      end

    end
  end
end