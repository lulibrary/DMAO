module Admin

  class AdminController < ApplicationController

    before_action :authenticate_dmao_admin!

  end

end