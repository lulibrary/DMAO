module JSONIngesters

  class OrganisationIngester < DMAO::Ingesters::OrganisationIngester

    def initialize

      namespace = "json_organisation_ingester"

      super(namespace)

    end

    def ingest(options={})

      options.assert_valid_keys(:file)

      organisation_units = parse_file options[:file]

      add_organisation_units organisation_units

      link_organisation_units organisation_units

    end

    def parse_file filepath

      begin

        file = File.read(filepath)

        organisation_units = JSON.parse(file)["organisation_units"]

      rescue Errno::ENOENT

        raise DMAO::Ingesters::IngestFileError.new "Error reading file no such file or directory @ #{filepath}"

      rescue JSON::ParserError

        raise DMAO::Ingesters::IngestFileError.new "Error reading file, invalid json data in #{filepath}"

      end

      if organisation_units.nil?
        raise DMAO::Ingesters::IngestFileError.new "Error with JSON data, no organisation units array defined in #{filepath}"
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

        new_org_unit = add_organisation_unit details

        cache_uuid_mapping system_uuid, new_org_unit

      end

    end

    def link_organisation_units organisation_units

      organisation_units.each do |org_unit|

        child = get_system_uuid_mapping org_unit["system"]["uuid"]

        if org_unit["parent"]["uuid"].present?
          parent = get_system_uuid_mapping org_unit["parent"]["uuid"]
          link_child_to_parent child, parent
        end

      end

    end

  end

end