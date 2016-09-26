module Admin

  class AdminController < ApplicationController

    layout 'admin'

    before_action :authenticate_dmao_admin!
    before_action :set_raven_admin_context

    private

    def set_raven_admin_context
      Raven.user_context(id: current_dmao_admin.id, type: "DMAO Admin")
    end

  end

end