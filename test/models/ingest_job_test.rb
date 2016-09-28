require 'test_helper'

class IngestJobTest < ActiveSupport::TestCase

  def setup
    @ingest_job = ingest_jobs(:ingest)
  end

  test 'is a valid ingest job' do
    assert @ingest_job.valid?
  end

  test 'is invalid without status' do
    @ingest_job.status = nil
    refute @ingest_job.valid?
  end

  test 'is invalid without institution' do
    @ingest_job.institution = nil
    refute @ingest_job.valid?
  end

  test 'is invalid without ingest area' do
    @ingest_job.ingest_area = nil
    refute @ingest_job.valid?
  end

  test 'is invalid if ingest area is not list of valid ingest areas' do
    @ingest_job.ingest_area = "testing"
    refute @ingest_job.valid?
  end

  test 'is valid if ingest area is in list of valid ingest areas' do

    ingest_areas = %w{organisation}

    ingest_areas.each do |area|
      @ingest_job.ingest_area = area
      assert @ingest_job.valid?
    end

  end

  test 'is invalid without ingest mode' do
    @ingest_job.ingest_mode = nil
    refute @ingest_job.valid?
  end

  test 'is invalid if ingest mode is not in list of valid ingest modes' do
    @ingest_job.ingest_mode = "testing"
    refute @ingest_job.valid?
  end

  test 'is valid if ingest mode is in list of valid ingest modes' do

    ingest_modes = %w{automatic manual}

    ingest_modes.each do |mode|
      @ingest_job.ingest_mode = mode
      assert @ingest_job.valid?
    end

  end

  test 'is invalid without ingest type' do
    @ingest_job.ingest_type = nil
    refute @ingest_job.valid?
  end

  test 'is invalid if ingest type is not in list of valid ingest types' do
    @ingest_job.ingest_type = "testing"
    refute @ingest_job.valid?
  end

  test 'is valid if ingest type is in list of valid ingest types' do

    ingest_types = %w{ingest refresh}

    ingest_types.each do |type|
      @ingest_job.ingest_type = type
      assert @ingest_job.valid?
    end

  end

end
