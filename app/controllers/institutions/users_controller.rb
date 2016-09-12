module Institutions

  class UsersController < InstitutionsController

    def index

      @institution_users = Institution::User.all

    end

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

    def edit

      begin

        @institution_user = Institution::User.find(params[:id])

      rescue ActiveRecord::RecordNotFound

        head(:not_found)

      end

    end

    def update

      begin

        @institution_user = Institution::User.find(params[:id])

      rescue ActiveRecord::RecordNotFound

        return head(:not_found)

      end

      if @institution_user.update institution_user_params

        redirect_to institution_user_path(id: @institution_user)

      else

        render 'edit'

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