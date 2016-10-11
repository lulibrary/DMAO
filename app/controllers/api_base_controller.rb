class ApiBaseController < ActionController::API

  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :set_raven_context

  private

  def set_raven_context
    Raven.extra_context(params: params.to_h, url: request.url, api: "API")
  end

end