require 'test_helper'

class IngestFileErrorTest < ActiveSupport::TestCase

  test "returns ingest file error with message set to default when initialised empty" do

    error = DMAO::Ingesters::Errors::IngestFileError.new

    assert_instance_of DMAO::Ingesters::Errors::IngestFileError, error
    assert_equal "Error finding file", error.message

  end

  test "return ingest file error with validation errors set to nil when initialised empty" do

    error = DMAO::Ingesters::Errors::IngestFileError.new

    assert_instance_of DMAO::Ingesters::Errors::IngestFileError, error
    assert_nil error.validation_errors

  end

  test 'returns ingest file error with set message when calling initialise with message' do

    error = DMAO::Ingesters::Errors::IngestFileError.new ("Test error message")

    assert_instance_of DMAO::Ingesters::Errors::IngestFileError, error
    assert_equal "Test error message", error.message

  end

  test 'returns ingest file error with set message and validation errors when calling initialise with message and errors' do

    error = DMAO::Ingesters::Errors::IngestFileError.new("Test error message", "validation errors")

    assert_instance_of DMAO::Ingesters::Errors::IngestFileError, error
    assert_equal "Test error message", error.message
    assert_equal "validation errors", error.validation_errors

  end

  test 'should be a type of ingest error' do

    error = DMAO::Ingesters::Errors::IngestFileError.new

    assert_instance_of DMAO::Ingesters::Errors::IngestFileError, error
    assert_kind_of DMAO::Ingesters::Errors::IngestError, error

  end

end
