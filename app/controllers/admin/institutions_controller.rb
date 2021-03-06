module Admin

  class InstitutionsController < AdminController

    def new
      @institution = Institution.new
    end

    def create

      @institution = Institution.new institution_params

      if @institution.save
        redirect_to [:admin, @institution]
      else
        render 'new'
      end

    end

    def show

      begin
        @institution = Institution.find(params[:id])
        @institution_admins = @institution.admins
      rescue ActiveRecord::RecordNotFound
        head(:not_found)
      end

    end

    def update
      begin
        @institution = Institution.find(params[:id])
        if @institution.update institution_params
          redirect_to [:admin, @institution]
        else
          render 'edit'
        end
      rescue ActiveRecord::RecordNotFound
        head(:not_found)
      end
    end

    def edit
      begin
        @institution = Institution.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        head(:not_found)
      end
    end

    def destroy
      begin
        @institution = Institution.find(params[:id])
        @institution.destroy
        redirect_to admin_institutions_path
      rescue ActiveRecord::RecordNotFound
        head(:not_found)
      end
    end

    def index
      @institutions = Institution.all
    end

    private

    def institution_params
      params
        .require(:institution)
        .permit(
          :name,
          :identifier,
          :contact_name,
          :contact_email,
          :contact_phone_number,
          :url,
          :description
        )
    end

  end

end
