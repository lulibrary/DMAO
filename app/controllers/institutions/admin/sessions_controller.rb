module Institutions

  module Admin

    class SessionsController < Devise::SessionsController

      include Institutions::InstitutionDetails

      layout 'auth'

    end

  end

end