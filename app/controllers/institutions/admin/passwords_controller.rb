module Institutions

  module Admin

    class PasswordsController < Devise::PasswordsController

      include Institutions::InstitutionDetails

      layout 'auth'

    end

  end

end