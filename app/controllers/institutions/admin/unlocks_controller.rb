module Institutions

  module Admin

    class UnlocksController < Devise::UnlocksController

      include Institutions::InstitutionDetails

      layout 'auth'

    end

  end

end