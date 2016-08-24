module Admin
  module DmaoUsers
    class UnlocksController < Devise::UnlocksController
      layout 'auth'
    end
  end
end
