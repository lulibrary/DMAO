require 'test_helper'

class IngestErrortest < ActiveSupport::TestCase

  test "returns ingest error with message set to default when initialised empty" do

    error = DMAO::Ingesters::Errors::IngestError.new

    assert_instance_of DMAO::Ingesters::Errors::IngestError, error
    assert_equal "Error ingesting object to system", error.message

  end

  test "return ingest error with validation errors set to nil when initialised empty" do

    error = DMAO::Ingesters::Errors::IngestError.new

    assert_instance_of DMAO::Ingesters::Errors::IngestError, error
    assert_nil error.validation_errors

  end

  test 'returns ingest error with set message when calling initialise with message' do

    error = DMAO::Ingesters::Errors::IngestError.new ("Test error message")

    assert_instance_of DMAO::Ingesters::Errors::IngestError, error
    assert_equal "Test error message", error.message

  end

  test 'returns ingest error with set message and validation errors when calling initialise with message and errors' do

    error = DMAO::Ingesters::Errors::IngestError.new("Test error message", "validation errors")

    assert_instance_of DMAO::Ingesters::Errors::IngestError, error
    assert_equal "Test error message", error.message
    assert_equal "validation errors", error.validation_errors

  end

end
