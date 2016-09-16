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

      def create

        begin

          @institution = Institution.find(params[:institution_id])

        rescue ActiveRecord::RecordNotFound

          return head(:not_found)

        end

        # create config object

        systems_configuration = ::CreateSystemsConfiguration.new(@institution, configuration_params[:systems_configuration].to_h).call

        @configuration = ::Institution::Configuration.new(institution_id: @institution.id)

        if systems_configuration.errors.any?

          @configuration.errors.add(:systems_configuration, systems_configuration.errors)

        else

          @configuration.systems_configuration = systems_configuration

          if @configuration.save

            return redirect_to admin_institution_configuration_path(institution_id: @institution.id, id: @configuration.id)

          end

        end

        render 'new'

      end

      private

      def configuration_params

        params
            .require(:institution_configuration)
            .permit(
                systems_configuration: [
                    cris_system: [
                        :system_id,
                        configuration_key_values: [
                            :value
                        ]
                    ]
                ]
            )

      end

    end
  end
end