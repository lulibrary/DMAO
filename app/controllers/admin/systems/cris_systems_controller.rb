module Admin
  module Systems
    class CrisSystemsController < ::Admin::AdminController

      def index

        @cris_systems = ::Systems::CrisSystem.all

      end

      def show

        begin

          @cris_system = ::Systems::CrisSystem.find(params[:id])

        rescue ActiveRecord::RecordNotFound

          head(:not_found)

        end

      end

      def new

        @cris_system = ::Systems::CrisSystem.new

      end

      def create

        @cris_system = ::Systems::CrisSystem.new(cris_system_params)

        if @cris_system.save
          redirect_to admin_systems_cris_system_path @cris_system
        else
          render 'new'
        end

      end

      def config_keys

        begin

          cris_system = ::Systems::CrisSystem.find(params[:id])

          @config_keys = cris_system.configuration_keys

          respond_to do |format|
            format.json { render json: @config_keys }
          end

        rescue ActiveRecord::RecordNotFound, ActionController::UnknownFormat

          head(:not_found)

        end

      end

      private

      def cris_system_params

        params.require(:systems_cris_system).permit(:name, :description, :version, :organisation_ingester, configuration_keys_attributes: [:name, :display_name, :secure])

      end

    end
  end
end