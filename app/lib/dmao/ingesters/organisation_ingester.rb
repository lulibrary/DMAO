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

      def link_child_to_parent child_uuid, parent_uuid

        begin
          child = Institution::OrganisationUnit.find(child_uuid)
        rescue ActiveRecord::RecordNotFound
          raise IngestError.new("Error finding organisation unit with uuid #{child_uuid}. Cannot link from non-existent child.")
        end

        begin
          parent = Institution::OrganisationUnit.find(parent_uuid)
        rescue ActiveRecord::RecordNotFound
          raise IngestError.new("Error finding organisation unit with uuid #{parent_uuid}. Cannot link child to non-existent parent.")
        end

        child.parent = parent

        if child.save
          true
        else
          raise IngestError.new("Error linking child organisation unit to parent organisation unit.")
        end

      end

    end

  end
end