module Admin
  module DmaoUsers
    class PasswordsController < Devise::PasswordsController
      layout 'auth'
    end
  end
end
