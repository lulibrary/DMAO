module Admin
  module DmaoAdmins
    class SessionsController < Devise::SessionsController
      layout 'auth'
    end
  end
end
