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

      private

      def cris_system_params

        params.require(:systems_cris_system).permit(:name, :description, :version, configuration_keys_attributes: [:name, :display_name])

      end

    end
  end
end