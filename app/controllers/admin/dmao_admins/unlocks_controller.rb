module Admin
  module DmaoAdmins
    class UnlocksController < Devise::UnlocksController
      layout 'auth'
    end
  end
end
