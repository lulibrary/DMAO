require 'test_helper'

class OrganisationIngesterTest < ActiveSupport::TestCase

  def setup
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

  test 'should raise ingest error when failing to save organisation unit' do

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

    error = assert_raises DMAO::Ingesters::IngestError do
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

    error = assert_raises DMAO::Ingesters::IngestError do
      @organisation_ingester.ingest
    end

    assert_equal "Calling ingest on generic organisation ingester is not allowed", error.message
    assert_nil error.validation_errors

  end

  test 'link - should raise error when child OU cannot be found' do

    ou_1 = institution_organisation_units(:one)
    ou_2 = institution_organisation_units(:two)

    error = assert_raises DMAO::Ingesters::IngestError do
      @organisation_ingester.link_child_to_parent "testing", ou_2.id
    end

    assert_equal "Error finding organisation unit with uuid testing. Cannot link from non-existent child.", error.message

  end

  test 'link - should raise error when parent OU cannot be found' do

    ou_1 = institution_organisation_units(:one)
    ou_2 = institution_organisation_units(:two)

    error = assert_raises DMAO::Ingesters::IngestError do
      @organisation_ingester.link_child_to_parent ou_1.id, "testing"
    end

    assert_equal "Error finding organisation unit with uuid testing. Cannot link child to non-existent parent.", error.message

  end

  test 'should return true when both child and parent OU uuids are valid' do

    ou_1 = institution_organisation_units(:one)
    ou_2 = institution_organisation_units(:two)

    assert @organisation_ingester.link_child_to_parent ou_2.id, ou_1.id

    parent = Institution::OrganisationUnit.find(ou_1.id)

    assert_equal parent, ou_1

  end

  test 'should raise ingest error when error saving child/parent relationship' do

    ou_1 = institution_organisation_units(:one)
    ou_2 = institution_organisation_units(:two)

    Institution::OrganisationUnit.any_instance.expects(:save).once.returns false

    error = assert_raises DMAO::Ingesters::IngestError do
      @organisation_ingester.link_child_to_parent ou_2.id, ou_1.id
    end

    assert_equal "Error linking child organisation unit to parent organisation unit.", error.message

  end

end