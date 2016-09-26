module Institutions

  module Admin

    class SessionsController < Devise::SessionsController

      include Institutions::InstitutionDetails

      layout 'auth'

      private

      def after_sign_out_path_for(resource)

        stored_location_for(resource) || institution_dashboard_path

      end

    end

  end

end