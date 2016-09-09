module Institutions

  module InstitutionDetails
    extend ActiveSupport::Concern

    included do
      before_action :current_institution
      around_action :scope_current_institution
    end

    def current_institution

      begin
        @institution = Institution.find_by_identifier!(params[:institution_identifier])
      rescue ActiveRecord::RecordNotFound
        head(:not_found)
      end

    end

    def scope_current_institution
      Institution.current_id = @institution.id
      yield
    ensure
     Institution.current_id = nil
    end

  end

end