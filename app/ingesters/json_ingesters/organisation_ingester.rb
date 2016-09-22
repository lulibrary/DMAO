module JSONIngesters

  class OrganisationIngester < DMAO::Ingesters::OrganisationIngester

    def initialize

      namespace = "json_organisation_ingester"

      super(namespace)

    end

    def ingest(options={})

      options.assert_valid_keys(:file)

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

  end

end