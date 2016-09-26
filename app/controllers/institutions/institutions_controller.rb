module Institutions

  class InstitutionsController < ApplicationController

    layout 'institution_admin'

    include Institutions::InstitutionDetails

    before_action :authenticate_institution_admin!
    before_action :set_raven_institution_context

    private

    def set_raven_institution_context
      Raven.user_context(id: current_institution_admin.id, type: "Institution Admin", institution_id: current_institution.id)
    end

  end

end