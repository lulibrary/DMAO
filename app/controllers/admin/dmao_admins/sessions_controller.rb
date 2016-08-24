module Admin
  module DmaoUsers
    class SessionsController < Devise::SessionsController
      layout 'auth'
    end
  end
end
