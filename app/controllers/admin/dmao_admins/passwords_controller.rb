module Admin
  module DmaoAdmins
    class PasswordsController < Devise::PasswordsController
      layout 'auth'
    end
  end
end
