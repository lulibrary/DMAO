require 'test_helper'

module JSONIngesters

  class OrganisationIngesterTest < ActiveSupport::TestCase

    def setup
      Institution.current_id = institutions(:luve).id
      @ingester = OrganisationIngester.new
      @valid_test_file_path = Rails.root.join('test/fixtures/files/json_organisation_units.json')
      @non_json_file_path = Rails.root.join('test/fixtures/files/non_json_organisation_units.json')
      @no_org_units_file_path = Rails.root.join('test/fixtures/files/no_organisation_units.json')
    end

    test 'should be an instance of generic organisation ingester' do
      assert_kind_of DMAO::Ingesters::OrganisationIngester, @ingester
    end

    test 'should have access to the generic organisation ingester methods' do

      assert_respond_to @ingester, :add_organisation_unit
      assert_respond_to @ingester, :link_child_to_parent
      assert_respond_to @ingester, :cache_uuid_mapping
      assert_respond_to @ingester, :get_system_uuid_mapping

    end

    test 'should have ingest method that accepts options hash with valid keys of file' do

      assert_nothing_raised do
        @ingester.ingest({file: @valid_test_file_path})
      end

    end

    test 'should have ingest method that raises argument error when invalid hash keys are passed in' do

      assert_raises ArgumentError do
        @ingester.ingest({testing_key: "testing value"})
      end

    end

    test 'should raise ingest file error when invalid filepath' do

      error = assert_raises DMAO::Ingesters::Errors::IngestFileError do
        @ingester.parse_file "/testing/nonexistent/file/path"
      end

      assert_equal "Error reading file no such file or directory @ /testing/nonexistent/file/path", error.message

    end

    test 'should raise ingest file error when contents is not json' do

      error = assert_raises DMAO::Ingesters::Errors::IngestFileError do
        @ingester.parse_file @non_json_file_path
      end

      assert_equal "Error reading file, invalid json data in #{@non_json_file_path}", error.message

    end

    test 'should raise ingest file error when contents does not contain organisation units array' do

      error = assert_raises DMAO::Ingesters::Errors::IngestFileError do
        @ingester.parse_file @no_org_units_file_path
      end

      assert_equal "Error with JSON data, no organisation units array defined in #{@no_org_units_file_path}", error.message

    end

    test 'parse file should return organisation units array when successfully parses file' do

      org_units = @ingester.parse_file(@valid_test_file_path)

      assert_equal 3, org_units.length

      assert_instance_of Array, org_units

    end

    test 'should add the organisation units to the database' do

      ingester_options = { file: @valid_test_file_path }

      assert_difference "Institution::OrganisationUnit.count", 3 do
        @ingester.ingest ingester_options
      end

    end

    test 'should cache the link between the system uuid and dmao uuid' do

      ingest_options = { file: @valid_test_file_path }

      units = JSON.parse(File.read(@valid_test_file_path))["organisation_units"]

      OrganisationIngester.any_instance.expects(:link_organisation_units)

      DMAO::Ingesters::OrganisationIngester.any_instance.expects(:add_organisation_unit).times(3).returns("123456")

      units.each do |unit|
        DMAO::Ingesters::OrganisationIngester.any_instance.expects(:cache_uuid_mapping).with(unit["system"]["uuid"], "123456")
      end

      @ingester.ingest ingest_options

    end

    test 'should link the child organisation units to their parent units' do

      ingest_options = { file: @valid_test_file_path }

      units = JSON.parse(File.read(@valid_test_file_path))["organisation_units"]

      with_parent = units.select { |u| u["parent"]["uuid"].present? }.size

      DMAO::Ingesters::OrganisationIngester.any_instance.expects(:link_child_to_parent).times(with_parent)

      @ingester.ingest ingest_options

    end

  end

end