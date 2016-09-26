module Admin
  module DmaoAdmins
    class SessionsController < Devise::SessionsController
      layout 'auth'

      private

      def after_sign_out_path_for(resource)

        stored_location_for(resource) || admin_dashboard_path

      end

    end
  end
end
