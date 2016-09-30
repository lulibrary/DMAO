require 'test_helper'

class Admin::Jobs::Institution::ManualIngestJobTest < ActiveJob::TestCase

  def setup
    @ingest_job = ingest_jobs(:ingest)
  end

  test 'should get ingest job from db for specified id' do

    IngestJob.expects(:find).with(@ingest_job.id).once

    ::Admin::Jobs::Institution::ManualIngestJob.perform_now @ingest_job.id

  end

  test 'should log error if ingest job id cannot be found' do

    Rails.logger.expects(:error).once

    ::Admin::Jobs::Institution::ManualIngestJob.perform_now 0

  end

end
