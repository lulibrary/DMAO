module JSONIngesters

  class OrganisationIngester < DMAO::Ingesters::OrganisationIngester

    def initialize

      namespace = "json_organisation_ingester"

      @ignore_for_linking_uuids = []

      super(namespace)

    end

    def ingest(options={})

      options.assert_valid_keys(:file)

      organisation_units = parse_file options[:file]

      add_organisation_units organisation_units

      link_organisation_units organisation_units

      close_log_file

      if logged_errors

        raise DMAO::Ingesters::Errors::IngestWithErrors.new "JSON organisation ingest completed with errors, see ingest log file.", get_log_file_path

      end

      true

    end

    def parse_file filepath

      begin

        file = File.read(filepath)

        organisation_units = JSON.parse(file)["organisation_units"]

      rescue Errno::ENOENT

        raise DMAO::Ingesters::Errors::IngestFileError.new "Error reading file no such file or directory @ #{filepath}"

      rescue JSON::ParserError

        raise DMAO::Ingesters::Errors::IngestFileError.new "Error reading file, invalid json data in #{filepath}"

      end

      if organisation_units.nil?
        raise DMAO::Ingesters::Errors::IngestFileError.new "Error with JSON data, no organisation units array defined in #{filepath}"
      end

      organisation_units

    end

    def add_organisation_units organisation_units

      organisation_units.each do |org_unit|

        system_uuid = org_unit["system"]["uuid"]

        details = {
            name: org_unit["details"]["name"],
            description: org_unit["details"]["description"],
            url: org_unit["details"]["url"],
            system_uuid: system_uuid,
            system_modified_at: Time.at(org_unit["system"]["modified_at"]),
            isni: org_unit["details"]["isni"],
            unit_type: org_unit["details"]["type"]
        }

        begin

          new_org_unit = add_organisation_unit details

          cache_uuid_mapping system_uuid, new_org_unit

        rescue DMAO::Ingesters::Errors::IngestSaveError, DMAO::Ingesters::Errors::IngestMappingSetError => e

          log_ingest_error system_uuid, e.message, e.validation_errors.to_json

          ignore_for_linking system_uuid

        end

      end

    end

    def link_organisation_units organisation_units

      organisation_units.each do |org_unit|

        child_uuid = org_unit["system"]["uuid"]
        parent_uuid = org_unit["parent"]["uuid"]

        next if @ignore_for_linking_uuids.include? child_uuid
        next if @ignore_for_linking_uuids.include? parent_uuid

        begin

          child = get_system_uuid_mapping child_uuid

          if parent_uuid.present?
            parent = get_system_uuid_mapping parent_uuid
            link_child_to_parent child, parent
          end

        rescue DMAO::Ingesters::Errors::IngestLinkChildError, DMAO::Ingesters::Errors::IngestLinkParentError => e

          log_ingest_error child_uuid, e.message, {}
          next

        rescue DMAO::Ingesters::Errors::IngestSaveError => e

          log_ingest_error child_uuid, e.message, e.validation_errors.to_json
          next

        end

      end

    end

    def ignore_for_linking system_uuid
      @ignore_for_linking_uuids.append system_uuid
    end

  end

end