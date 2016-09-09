module Institutions

  module InstitutionDetails
    extend ActiveSupport::Concern

    included do
      before_action :current_institution
    end

    def current_institution

      # byebug

      begin
        @institution = Institution.find_by_identifier!(params[:institution_identifier])
      rescue ActiveRecord::RecordNotFound
        head(:not_found)
      end

    end

  end

end