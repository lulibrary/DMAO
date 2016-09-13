module Admin
  module Systems
    class CrisSystemsController < ::Admin::AdminController

      def index

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

        params.require(:cris_system).permit(:name, :description, :version)

      end

    end
  end
end