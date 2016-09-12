module Institutions

  class UsersController < InstitutionsController

    def new

      @institution_user = Institution::User.new

    end

    def create

      @institution_user = Institution::User.new(institution_user_params)

      if @institution_user.save
        redirect_to institution_users_path
      else
        render 'new'
      end

    end

    private

    def institution_user_params
      params
          .require(:institution_user)
          .permit(
              :name,
              :email
          ).merge(generate_password)
    end

    def generate_password
      password = SecureRandom.uuid
      {
          password: password,
          password_confirmation: password
      }
    end

  end

end