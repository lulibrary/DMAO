class ApiBaseController < ActionController::API

  protect_from_forgery with: :null_session

  before_action :set_raven_context

  private

  def set_raven_context
    Raven.extra_context(params: params.to_h, url: request.url, api: "API")
  end

end