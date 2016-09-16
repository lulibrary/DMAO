class PagesController < ApplicationController

  layout 'info'

  def home

    @institution = Institution.new
    @institutions = Institution.all

  end

  def institution_login

    begin

      institution = Institution.find(params[:institution][:id])

    rescue ActiveRecord::RecordNotFound

      return head(:not_found)

    end

    redirect_to new_institution_admin_session_path(institution_identifier: institution.identifier)

  end

end