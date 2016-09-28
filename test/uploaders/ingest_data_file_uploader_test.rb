require 'test_helper'

class IngestDataFileUploaderTest < ActiveSupport::TestCase

  def setup

    @ingest_job = ingest_jobs(:ingest)
    @uploader = IngestDataFileUploader.new(@ingest_job, :data_file)

    @test_file = File.open(Rails.root.join('test/fixtures/files/json_organisation_units.json'))
    @invalid_test_file = File.open(Rails.root.join('test/fixtures/files/test_log_file.log'))

  end

  test 'should store file' do

    assert @uploader.store!(@test_file)

  end

  test 'uploader should raise integrity error for any file that is not a log file' do

    assert_raises CarrierWave::IntegrityError do
      @uploader.store!(@invalid_test_file)
    end

  end

  test 'allowed extensions should include json' do

    assert_includes @uploader.extension_white_list, "json"

  end

  test 'allowed extensions should not include log' do
    assert_not_includes @uploader.extension_white_list, "log"
  end

end