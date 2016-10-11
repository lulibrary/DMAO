module API
  module Authentication

    module ServiceTokenAuth
      extend ActiveSupport::Concern

      included do
        before_action :auth_with_service_token
      end

      protected

      def auth_with_service_token

        authenticate_token || render_unauthorised

      end

      def authenticate_token

        authenticate_with_http_token do |token, _options|
          Service::ApiToken.find_by(token: token)
        end

      end

      def render_unauthorised

        render json: 'Invalid service API token', status: 401

      end

    end

  end
end