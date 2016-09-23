require 'test_helper'

class OrganisationIngesterTest < ActiveSupport::TestCase

  def setup
    Institution.current_id = institutions(:luve).id
    @current_institution_id = Institution.current_id
    @organisation_ingester = DMAO::Ingesters::OrganisationIngester.new
  end

  test 'should raise argument error when invalid keys are passed in attributes hash' do

    assert_raises ArgumentError do
      @organisation_ingester.add_organisation_unit({invalid_key_name: "invalid key value"})
    end

  end

  test 'should call new on organisation unit with passed in attributes' do

    attributes = {
        name: "Test organisation unit",
        description: "",
        url: "",
        system_uuid: SecureRandom.uuid,
        system_modified_at: Time.now,
        isni: "",
        unit_type: "Test"
    }

    org_unit = Institution::OrganisationUnit.new(attributes)

    Institution::OrganisationUnit.expects(:new).once.with(attributes).returns(org_unit)

    @organisation_ingester.add_organisation_unit attributes

  end

  test 'should raise ingest save error when failing to save organisation unit' do

    attributes = {
        name: "Test organisation unit",
        description: "",
        url: "",
        system_uuid: SecureRandom.uuid,
        system_modified_at: Time.now,
        isni: "",
        unit_type: "Test"
    }

    Institution::OrganisationUnit.any_instance.expects(:save).once.returns(false)

    error = assert_raises DMAO::Ingesters::Errors::IngestSaveError do
      @organisation_ingester.add_organisation_unit attributes
    end

    assert_equal "Error ingesting organisation unit, failed to save", error.message

  end

  test 'should increase organisation unit count when adding new organisation unit' do

    attributes = {
        name: "Test organisation unit",
        description: "",
        url: "",
        system_uuid: SecureRandom.uuid,
        system_modified_at: Time.now,
        isni: "",
        unit_type: "Test"
    }

    assert_difference "Institution::OrganisationUnit.count" do

      @organisation_ingester.add_organisation_unit attributes

    end

  end

  test 'should return id of organisation unit when successfully saved' do

    system_uuid = SecureRandom.uuid

    attributes = {
        name: "Test organisation unit",
        description: "",
        url: "",
        system_uuid: system_uuid,
        system_modified_at: Time.now,
        isni: "",
        unit_type: "Test"
    }

    response = @organisation_ingester.add_organisation_unit attributes

    assert_equal Institution::OrganisationUnit.find_by(system_uuid: system_uuid).id, response

  end

  test 'should raise ingest error when trying to call ingest on organisation ingester' do

    error = assert_raises DMAO::Ingesters::Errors::IngestError do
      @organisation_ingester.ingest
    end

    assert_equal "Calling ingest on generic organisation ingester is not allowed", error.message
    assert_nil error.validation_errors

  end

  test 'link - should raise link child error when child OU cannot be found' do

    ou_1 = institution_organisation_units(:one)
    ou_2 = institution_organisation_units(:two)

    error = assert_raises DMAO::Ingesters::Errors::IngestLinkChildError do
      @organisation_ingester.link_child_to_parent "testing", ou_2.id
    end

    assert_equal "Error finding organisation unit with uuid testing. Cannot link from non-existent child.", error.message

  end

  test 'link - should raise link parent error when parent OU cannot be found' do

    ou_1 = institution_organisation_units(:one)
    ou_2 = institution_organisation_units(:two)

    error = assert_raises DMAO::Ingesters::Errors::IngestLinkParentError do
      @organisation_ingester.link_child_to_parent ou_1.id, "testing"
    end

    assert_equal "Error finding organisation unit with uuid testing. Cannot link child to non-existent parent.", error.message

  end

  test 'should return true when both child and parent OU uuids are valid' do

    ou_1 = institution_organisation_units(:one)
    ou_2 = institution_organisation_units(:two)

    assert @organisation_ingester.link_child_to_parent ou_2.id, ou_1.id

    parent = Institution::OrganisationUnit.find(ou_2.id).parent

    assert_equal parent, ou_1

  end

  test 'should raise ingest save error when error saving child/parent relationship' do

    ou_1 = institution_organisation_units(:one)
    ou_2 = institution_organisation_units(:two)

    Institution::OrganisationUnit.any_instance.expects(:save).once.returns false

    error = assert_raises DMAO::Ingesters::Errors::IngestSaveError do
      @organisation_ingester.link_child_to_parent ou_2.id, ou_1.id
    end

    assert_equal "Error linking child organisation unit to parent organisation unit.", error.message

  end

  test 'should set redis namespace to contain organisation ingest with institution id and timestamp when not specified' do

    nil_namespace = "organisation_ingest_7890_123456"

    Time.expects(:now).at_least_once.returns(123456)
    Institution.expects(:current_id).at_least_once.returns(7890)
    Redis::Namespace.expects(:new).once.with(nil_namespace, redis: $redis)

    DMAO::Ingesters::OrganisationIngester.new

  end

  test 'should raise ingest without institution error if Institution current id is not set' do

    Institution.expects(:current_id).once.returns(nil)

    error = assert_raises DMAO::Ingesters::Errors::IngestWithoutInstitutionError do
      DMAO::Ingesters::OrganisationIngester.new
    end

    assert_equal "Cannot initialise organisation ingester unless institution current id is set", error.message

  end

  test 'should set redis namespace to contain specified namespace with institution id and timestamp' do

    namespace = "my_test_namespace_7890_123456"

    Time.expects(:now).at_least_once.returns(123456)
    Institution.expects(:current_id).at_least_once.returns(7890)
    Redis::Namespace.expects(:new).once.with(namespace, redis: $redis)

    DMAO::Ingesters::OrganisationIngester.new "my_test_namespace"

  end

  test 'should set redis key for system uuid with value of dmao uuid in namespace' do

    Time.expects(:now).at_least_once.returns(123456)

    organisation_ingester = DMAO::Ingesters::OrganisationIngester.new

    organisation_ingester.cache_uuid_mapping "system_uuid", "dmao_uuid"

    namespace = "organisation_ingest_#{Institution.current_id}_123456"

    assert_equal "dmao_uuid", $redis.get("#{namespace}:system_uuid")

  end

  test 'should raise ingest error if redis key cannot be set for system uuid in namespace' do

    Redis::Namespace.any_instance.expects(:set).once.returns(false)

    error = assert_raises DMAO::Ingesters::Errors::IngestMappingSetError do
      @organisation_ingester.cache_uuid_mapping "system_uuid", "dmao_uuid"
    end

    assert_equal "Error caching mapping between system uuid system_uuid and DMAO uuid dmao_uuid", error.message

  end

  test 'should raise ingest error if redis key cannot be found for system uuid in namespace' do

    Redis::Namespace.any_instance.expects(:get).once.returns(nil)

    error = assert_raises DMAO::Ingesters::Errors::IngestMappingGetError do
      @organisation_ingester.get_system_uuid_mapping "system_uuid"
    end

    assert_equal "Error retrieving uuid mapping for system uuid system_uuid", error.message

  end

  test 'should return value for redis key when is a valid system uuid key in namespace' do

    @organisation_ingester.cache_uuid_mapping "system_uuid", "dmao_uuid"

    assert_equal "dmao_uuid", @organisation_ingester.get_system_uuid_mapping("system_uuid")

  end

  test 'should call create logger with organisation ingest namespace when no namepsace passed in' do

    DMAO::Ingesters::OrganisationIngester.any_instance.expects(:create_logger).once.with("organisation_ingest_#{@current_institution_id}")

    DMAO::Ingesters::OrganisationIngester.new

  end

  test 'should call create logger with namespace passed in if specified' do

    DMAO::Ingesters::OrganisationIngester.any_instance.expects(:create_logger).once.with("testing_ingest_#{@current_institution_id}")

    DMAO::Ingesters::OrganisationIngester.new "testing_ingest"

  end

end