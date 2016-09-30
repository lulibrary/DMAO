require 'test_helper'

class Admin::Jobs::Institution::ManualIngestJobTest < ActiveJob::TestCase

  def setup
    @ingest_job = ingest_jobs(:ingest)
  end

  test 'should get ingest job from db for specified id' do

    cris_system = systems_cris_systems(:one)

    ::Configuration::System::CrisSystem.any_instance.expects(:details).at_least_once.returns(cris_system)

    IngestJob.expects(:find).with(@ingest_job.id).once.returns(@ingest_job)

    ::Admin::Jobs::Institution::ManualIngestJob.perform_now @ingest_job.id

  end

  test 'should log error if ingest job id cannot be found' do

    Rails.logger.expects(:error).once

    ::Admin::Jobs::Institution::ManualIngestJob.perform_now 0

  end

  test 'should schedule ingester ingest job when valid manual ingest job' do

    cris_system = systems_cris_systems(:one)

    ::Configuration::System::CrisSystem.any_instance.expects(:details).at_least_once.returns(cris_system)

    assert_enqueued_with(job: Admin::Jobs::IngesterIngestJob) do

      ::Admin::Jobs::Institution::ManualIngestJob.perform_now @ingest_job.id

    end

  end

end
