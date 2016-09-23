class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_raven_context

  private

  def set_raven_context
    Raven.extra_context(params: params.to_h, url: request.url)
  end

end
