require 'test_helper'

class IngestLoggerTest < ActiveSupport::TestCase

  def setup
    @logger = DMAO::Ingesters::IngestLogger.new
  end

  test 'logger is an instance of ingest logger' do
    assert_instance_of DMAO::Ingesters::IngestLogger, @logger
  end

  test 'logger should extend the ruby logger' do
    assert_kind_of Logger, @logger
  end

  test 'logger should create file called new ingest with time when nil is passed on new' do

    Time.expects(:now).at_least_once.returns(12345)

    log_folder = Rails.application.config_for(:dmao)["ingest_log"]["directory"]

    DMAO::Ingesters::IngestLogger.new

    assert File.exists?("#{log_folder}/new_ingest_12345.log")

  end

  test 'logging new message should format to the log message format' do

    time = Time.now
    time_formatted = time.strftime("%Y-%m-%d %H:%M:%S")

    file = Rails.application.config_for(:dmao)["ingest_log"]["directory"] + "/new_ingest_#{time.to_i}.log"

    @logger = DMAO::Ingesters::IngestLogger.new

    Time.expects(:now).at_least_once.returns(time)

    test_log_message = [
        {
            status: "debug",
            msg: "Testing debug message"
        },
        {
            status: "info",
            msg: "Testing info message"
        },
        {
            status: "warn",
            msg: "Testing warn message"
        },
        {
            status: "error",
            msg: "Testing error message"
        },
        {
            status: "fatal",
            msg: "Testing fatal message"
        },
        {
            call: "unknown",
            status: "any",
            msg: "Testing unknown message"
        }
    ]

    test_log_message.each do |log|

      if log[:call].nil?
        @logger.send log[:status], log[:msg]
      else
        @logger.send log[:call], log[:msg]
      end

      log_line = IO.readlines(file)[-1..-1].first

      assert_match /^\[(\w*)\s*(\d{4}-\d{2}-\d{2}\s*\d{2}:\d{2}:\d{2})\]\s{1}(.*)/, log_line

      log_line_groups = /^\[(\w*)\s*(\d{4}-\d{2}-\d{2}\s*\d{2}:\d{2}:\d{2})\]\s{1}(.*)/.match(log_line)

      assert_equal log[:status].upcase, log_line_groups[1]
      assert_equal time_formatted, log_line_groups[2]
      assert_equal log[:msg], log_line_groups[3]

    end



  end

  test 'when initialising should set log file path to be the path to the logger' do

    Time.expects(:now).at_least_once.returns(12345)

    log_folder = Rails.application.config_for(:dmao)["ingest_log"]["directory"]

    ingester = DMAO::Ingesters::IngestLogger.new

    assert_equal "#{log_folder}/new_ingest_12345.log", ingester.log_file_path

  end

end