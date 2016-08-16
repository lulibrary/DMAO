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