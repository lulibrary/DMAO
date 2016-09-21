module DMAO
  module Ingesters

    class OrganisationIngester

      def ingest options={}
        raise IngestError.new("Calling ingest on generic organisation ingester is not allowed")
      end

      def add_organisation_unit attributes={}

        attributes.assert_valid_keys(:name, :description, :url, :system_uuid, :system_modified_at, :isni, :unit_type)

        organisation_unit = Institution::OrganisationUnit.new(attributes)

        if organisation_unit.save
          organisation_unit.id
        else
          raise IngestError.new("Error ingesting organisation unit, failed to save", organisation_unit.errors)
        end

      end

    end

  end
end