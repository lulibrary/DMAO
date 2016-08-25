module Admin
  class InstitutionAdminsController < AdminController

    def new
      begin
        institution = Institution.find params[:institution_id]
        @institution_admin = institution.admins.new
      rescue
        head(:not_found)
      end
    end


    def create
      begin
        institution = Institution.find params[:institution_id]
        @institution_admin = institution.admins.new admin_params
      rescue
        return head(:not_found)
      end

      if @institution_admin.save
        redirect_to admin_institution_admin_path(id: @institution_admin)
      else
        render 'new'
      end

    end

    def show

      begin
        institution = Institution.find params[:institution_id]
        @institution_admin = institution.admins.find params[:id]
      rescue
        head(:not_found)
      end

    end

    private

    def admin_params
      params
          .require(:institution_admin)
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