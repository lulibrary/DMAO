module Api
  module V1

    class OrganisationUnitsController < BaseController

      def create

        begin

          institution = Institution.find params[:institution_id]

        rescue ActiveRecord::RecordNotFound
          return render json: {
              errors: {
                  institution_id: "Institution not found for institution id #{params[:institution_id]}"
              }
          }, status: :not_found
        end

        organisation_unit = institution.organisation_units.new(organisation_unit_params)

        if organisation_unit.save
          render json: organisation_unit, serializer: Api::V1::OrganisationUnitSerializer, status: :created
        else
          render json: {
              errors: organisation_unit.errors
          }, status: :unprocessable_entity
        end

      end

      def update

        begin

          institution = Institution.find params[:institution_id]

          Institution.current_id = institution.id

        rescue ActiveRecord::RecordNotFound
          return render json: {
              errors: {
                  institution_id: "Institution not found for institution id #{params[:institution_id]}"
              }
          }, status: :not_found
        end

        begin

          organisation_unit = Institution::OrganisationUnit.find params[:id]

        rescue ActiveRecord::RecordNotFound

          return render json: {
              errors: {
                  organisation_unit: "Organisation unit not found for organisation unit id #{params[:id]}"
              }
          }, status: :not_found

        end

        if params[:parent_uuid].present?

          begin

            parent_organisation_unit = Institution::OrganisationUnit.find params[:parent_uuid]

          rescue ActiveRecord::RecordNotFound

            return render json: {
                errors: {
                    parent_uuid: "Organisation unit not found for parent uuid #{params[:parent_uuid]}"
                }
            }, status: :unprocessable_entity

          end

          organisation_unit.parent = parent_organisation_unit

        end

        if organisation_unit.update(organisation_unit_params)
          render json: organisation_unit, serializer: Api::V1::OrganisationUnitSerializer, status: :ok
        else
          render json: {
              errors: organisation_unit.errors
          }, status: :unprocessable_entity
        end

      end

      private

      def organisation_unit_params
        params
            .permit(
                :name,
                :description,
                :url,
                :system_uuid,
                :system_modified_at,
                :isni,
                :unit_type
            )
            .merge(
                {
                    system_modified_at: Time.at(params['system_modified_at'].to_i)
                }
            )
      end

    end

  end
end