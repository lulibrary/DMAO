module Institutions

  class UsersController < InstitutionsController

    def new

      @institution_user = Institution::User.new

    end

  end

end