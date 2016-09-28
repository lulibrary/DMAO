require 'test_helper'

class IngestLogFileUploaderTest < ActiveSupport::TestCase

  def setup

    @ingest_job = ingest_jobs(:ingest)
    @uploader = IngestLogFileUploader.new(@ingest_job, :file)

    @test_file = File.open(Rails.root.join('test/fixtures/files/test_log_file.log'))
    @invalid_test_file = File.open(Rails.root.join('test/fixtures/files/json_organisation_units.json'))

  end

  test 'should store file' do

    assert @uploader.store!(@test_file)

  end

  test 'uploader should raise integrity error for any file that is not a log file' do

    assert_raises CarrierWave::IntegrityError do
      @uploader.store!(@invalid_test_file)
    end

  end

  test 'allowed extensions should include log' do

    assert_includes @uploader.extension_white_list, "log"

  end

  test 'allowed extensions should not include json' do
    assert_not_includes @uploader.extension_white_list, "json"
  end

end