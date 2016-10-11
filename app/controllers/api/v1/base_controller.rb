module API:V1

  class BaseController < ::ApiBaseController

    before_action :set_raven_api_context

    include API::Authentication::ServiceTokenAuth

    private

    def set_raven_api_context
      Raven.extra_context(api: "V1")
    end

  end

end