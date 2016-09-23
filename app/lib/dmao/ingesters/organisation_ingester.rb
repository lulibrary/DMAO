module DMAO
  module Ingesters

    class OrganisationIngester

      def initialize namespace=nil

        if Institution.current_id.nil?
          raise Errors::IngestWithoutInstitutionError.new("Cannot initialise organisation ingester unless institution current id is set")
        end

        if namespace.nil? || namespace.empty?
          namespace = "organisation_ingest"
        end

        namespace += "_#{Institution.current_id}_#{Time.now.to_i}"

        @mapping_cache = Redis::Namespace.new(namespace, redis: $redis)

      end

      def ingest options={}
        raise Errors::IngestError.new("Calling ingest on generic organisation ingester is not allowed")
      end

      def add_organisation_unit attributes={}

        attributes.assert_valid_keys(:name, :description, :url, :system_uuid, :system_modified_at, :isni, :unit_type)

        organisation_unit = Institution::OrganisationUnit.new(attributes)

        if organisation_unit.save
          organisation_unit.id
        else
          raise Errors::IngestSaveError.new("Error ingesting organisation unit, failed to save", organisation_unit.errors)
        end

      end

      def link_child_to_parent child_uuid, parent_uuid

        begin
          child = Institution::OrganisationUnit.find(child_uuid)
        rescue ActiveRecord::RecordNotFound
          raise Errors::IngestLinkChildError.new("Error finding organisation unit with uuid #{child_uuid}. Cannot link from non-existent child.")
        end

        begin
          parent = Institution::OrganisationUnit.find(parent_uuid)
        rescue ActiveRecord::RecordNotFound
          raise Errors::IngestLinkParentError.new("Error finding organisation unit with uuid #{parent_uuid}. Cannot link child to non-existent parent.")
        end

        child.parent = parent

        if child.save
          true
        else
          raise Errors::IngestSaveError.new("Error linking child organisation unit to parent organisation unit.")
        end

      end

      def cache_uuid_mapping system_uuid, dmao_uuid

        set_cache_response = @mapping_cache.set(system_uuid, dmao_uuid)

        if set_cache_response == "OK"
          true
        else
          raise Errors::IngestMappingSetError.new("Error caching mapping between system uuid #{system_uuid} and DMAO uuid #{dmao_uuid}")
        end

      end

      def get_system_uuid_mapping system_uuid

        get_cache_response = @mapping_cache.get(system_uuid)

        if get_cache_response.nil?
          raise Errors::IngestMappingGetError.new("Error retrieving uuid mapping for system uuid #{system_uuid}")
        end

        get_cache_response

      end

    end

  end
end