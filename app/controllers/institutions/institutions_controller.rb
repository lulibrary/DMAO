module Institutions

  class InstitutionsController < ApplicationController

    include Institutions::InstitutionDetails

    before_action :authenticate_institution_admin!

  end

end